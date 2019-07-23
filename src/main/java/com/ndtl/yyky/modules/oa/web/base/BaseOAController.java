package com.ndtl.yyky.modules.oa.web.base;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Iterator;
import java.util.LinkedList;

import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.TaskService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.utils.excel.fieldtype.OfficeType;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAItem;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.FileMeta;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

public abstract class BaseOAController extends BaseController {

	protected LinkedList<FileMeta> files = new LinkedList<FileMeta>();
	protected FileMeta fileMeta = null;
	@Autowired
	protected TaskService taskService;

	public abstract BaseOAService getService();

	@RequestMapping(value = "assign/{tid}/{uid}")
	@ResponseBody
	public String assign(@PathVariable("tid") String taskId,
			@PathVariable("uid") String uId) {
		taskService.claim(taskId, uId);
		return "success";
	}

	@RequestMapping(value = "/upload/{type}", method = RequestMethod.POST)
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request,
			@PathVariable("type") String type) {
		Iterator<String> itr = request.getFileNames();
		MultipartFile mpf = null;
		while (itr.hasNext()) {
			mpf = request.getFile(itr.next());
			if (files.size() >= 1) {
				files.pop();
			}
			fileMeta = new FileMeta();
			fileMeta.setFileName(mpf.getOriginalFilename());
			fileMeta.setFileSize(mpf.getSize() / 1024 + " Kb");
			fileMeta.setFileType(mpf.getContentType());
			try {
				fileMeta.setBytes(mpf.getBytes());
				saveFileFromInputStream(
						mpf.getInputStream(),
						getFilePath(type,
								String.valueOf(UserUtils.getUser().getId())),
						mpf.getOriginalFilename());
			} catch (IOException e) {
				e.printStackTrace();
			}
			files.add(fileMeta);
		}
		ObjectMapper mapper= new ObjectMapper();
		String json=null;
		try {
			json=mapper.writeValueAsString(files);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}

	private void saveFileFromInputStream(InputStream inputStream, String path,
			String filename) throws IOException {
		File dir = new File(path);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		FileOutputStream fs = new FileOutputStream(dir + "/" + filename);
		byte[] buffer = new byte[1024 * 1024];
		int byteread = 0;
		while ((byteread = inputStream.read(buffer)) != -1) {
			fs.write(buffer, 0, byteread);
			fs.flush();
		}
		fs.close();
		inputStream.close();
	}

	public String getFilePath(String type, String id) {
		String result = Global.getSavedFilePath() + "/" + type + "_";
		if (StringUtils.isEmpty(id)) {
			result = result + UserUtils.getUser().getId() + "/";
		} else {
			result = result + id + "/";
		}
		return result;
	}

	@RequestMapping(value = "get/{id}", method = RequestMethod.GET)
	public void getFile(HttpServletResponse response, @PathVariable Long id,
			RedirectAttributes redirectAttributes) {
		BaseOAEntity entity = getService().findOne(id);
		String fileName = entity.getFile();
		this.getFile(response, id, redirectAttributes, fileName, entity
				.getClass().getSimpleName());
	}

	@RequestMapping(value = "get/{id}/{type}", method = RequestMethod.GET)
	public void getFile(HttpServletResponse response, @PathVariable Long id,
			@PathVariable String type, RedirectAttributes redirectAttributes) {
		BaseOAEntity entity = getService().findOne(id);
		String fileName = entity.getFile();
		this.getFile(response, id, redirectAttributes, fileName, type);
	}

	public void getFile(HttpServletResponse response, @PathVariable Long id,
			RedirectAttributes redirectAttributes, String fileName, String type) {
		BaseOAEntity entity = getService().findOne(id);
		String filePath = getFilePath(type,
				String.valueOf(entity.getCreateBy().getId()));
		File file = new File(filePath, fileName);
		try {
			String fName = new String(file.getName().getBytes(), "iso-8859-1");
			// 读到流中
			InputStream inStream = new FileInputStream(file.getAbsolutePath());// 文件的存放路径
			// 设置输出的格式
			response.reset();
			response.setContentType("multipart/form-data");
			response.addHeader("Content-Disposition", "attachment; filename=\""
					+ fName + "\"");
			// 循环取出流中的数据
			byte[] b = new byte[100];
			int len;
			while ((len = inStream.read(b)) > 0) {
				response.getOutputStream().write(b, 0, len);
			}
			inStream.close();
		} catch (UnsupportedEncodingException e1) {
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		} catch (FileNotFoundException e1) {
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		} catch (IOException e) {
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		}
	}

	protected void convertOffice(BaseOAItem entity) {
		entity.setOffice(OfficeType.getValue(entity.getOfficeName()));
	}
	
//	/**
//	 * 读取所有流程
//	 * 
//	 * @return
//	 */
//	@RequestMapping(value = { "listselected/{id}/{entitytype}" })
//	public ModelAndView listselected(@PathVariable("id")Long id,@PathVariable("entitytype")String type,HttpServletRequest request,
//			HttpServletResponse response) {
//		ModelAndView mav = new ModelAndView("modules/oa/"+type+"List");
//		BaseOAEntity entity = getService().findOne(id);
//		Page<BaseOAEntity> page = new Page<BaseOAEntity>(request,response);
//		page.getList().add(entity);
//		mav.addObject("page", page);
//		return mav;
//	}
}
