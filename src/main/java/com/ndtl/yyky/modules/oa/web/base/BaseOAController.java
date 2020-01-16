package com.ndtl.yyky.modules.oa.web.base;

import java.io.*;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
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

	//protected LinkedList<FileMeta> files = new LinkedList<FileMeta>();
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
	public String uploadFile(MultipartHttpServletRequest request,String node,
			@PathVariable("type") String type) {

		LinkedList<FileMeta> files = new LinkedList<FileMeta>();
		Iterator<String> itr = request.getFileNames();
		String filePath = String.valueOf(UserUtils.getUser().getId());
		MultipartFile mpf = null;

		if(StringUtils.equals(node,"midTemplete") || StringUtils.equals(node,"endTemplete")){
			filePath = node;
		}
		while (itr.hasNext()) {
			mpf = request.getFile(itr.next());

			fileMeta = new FileMeta();
			fileMeta.setFileName(mpf.getOriginalFilename());
			fileMeta.setFileSize(mpf.getSize() / 1024 + " Kb");
			fileMeta.setFileType(mpf.getContentType());
			try {
				fileMeta.setBytes(mpf.getBytes());
				saveFileFromInputStream(
						mpf.getInputStream(),
						getFilePath(type,filePath),
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

	public void saveFileFromInputStream(InputStream inputStream, String path,
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

	public Map getFilePathByWeb(String type, String id, HttpServletRequest request) {

		Map map = new HashMap<>();
		String servletPath = request.getSession().getServletContext().getRealPath("/");
		String relativePath = "/avatorImg/" + type + "_";
		if (StringUtils.isEmpty(id)) {
			relativePath = relativePath + UserUtils.getUser().getId() + "/";
		} else {
			relativePath = relativePath + id + "/";
		}
		map.put("servletPath",servletPath+relativePath);
		map.put("relativePath",relativePath);
		return map;
	}

	@RequestMapping(value = "get/{id}", method = RequestMethod.GET)
	public void getFile(HttpServletResponse response, @PathVariable Long id,
			RedirectAttributes redirectAttributes) throws Exception {
		BaseOAEntity entity = getService().findOne(id);
		String fileName = entity.getFile();
		this.multFileDownload(response, id, redirectAttributes, fileName, entity
				.getClass().getSimpleName());

	}

	@RequestMapping(value = "get/{id}/{type}", method = RequestMethod.GET)
	public void getFile(HttpServletResponse response, @PathVariable Long id,
			@PathVariable String type, RedirectAttributes redirectAttributes) throws Exception {
		BaseOAEntity entity = getService().findOne(id);
		String fileName = entity.getFile();
		this.multFileDownload(response, id, redirectAttributes, fileName, type);
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
				OutputStream out = response.getOutputStream();
				// 设置输出的格式
				response.setContentType("multipart/form-data");
				response.addHeader("Content-Disposition", "attachment; filename=\""
						+ fName + "\"");
				// 循环取出流中的数据
				byte[] b = new byte[100];
				int len;
				while ((len = inStream.read(b)) > 0) {
					out.write(b, 0, len);
				}
				out.flush();
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

	/**
	 * 1 多文件下载
	 * @param response HttpServletResponse
	 * @param fileName 待下载文件
	 * @throws Exception
	 * @date 2019年3月29日11:31:35
	 */
	public void multFileDownload(HttpServletResponse response, @PathVariable Long id,
								 RedirectAttributes redirectAttributes, String fileName, String type) throws Exception {
		List<String> files = new ArrayList<>();
		BaseOAEntity entity = getService().findOne(id);
		String filePath = getFilePath(type,
				String.valueOf(entity.getCreateBy().getId()));

		for(String name : fileName.split(",")){
			files.add(name);
		}

		response.setContentType("multipart/form-data");
		response.addHeader("Content-Disposition", "attachment; filename=\""
				+ StringUtils.join(System.currentTimeMillis(),".zip") + "\"");
		ServletOutputStream out;
		FileInputStream instream = null;
		try {
			ZipOutputStream zipstream=new ZipOutputStream(response.getOutputStream());
			for (String file:files) {
				if (!new File(filePath+file).exists()) {
					continue;
				}
				instream=new FileInputStream(filePath+file);
				ZipEntry entry = new ZipEntry(file);
				zipstream.putNextEntry(entry);
				byte[] buffer = new byte[1024];
				int len = 0;
				while (len != -1){
					len = instream.read(buffer);
					zipstream.write(buffer,0,buffer.length);
				}
				instream.close();
				zipstream.closeEntry();
				zipstream.flush();
			}
			zipstream.finish();
			zipstream.close();
		} catch (UnsupportedEncodingException e1) {
			logger.error("下载文件出错！",e1);
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		} catch (FileNotFoundException e1) {
			logger.error("下载文件出错！",e1);
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		} catch (IOException e) {
			logger.error("下载文件出错！",e);
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		}
	}

	/**
	 * 1 多文件下载
	 * @param response HttpServletResponse
	 * @param fileName 待下载文件
	 * @throws Exception
	 * @date 2019年3月29日11:31:35
	 */
	public void multTempFileDownload(HttpServletResponse response, String tempFile,
								 RedirectAttributes redirectAttributes, String fileName, String type) throws Exception {
		List<String> files = new ArrayList<>();
		String filePath = getFilePath(type,tempFile);

		for(String name : fileName.split(",")){
			files.add(name);
		}

		response.setContentType("multipart/form-data");
		response.addHeader("Content-Disposition", "attachment; filename=\""
				+ StringUtils.join(System.currentTimeMillis(),".zip") + "\"");
		ServletOutputStream out;
		FileInputStream instream = null;
		try {
			ZipOutputStream zipstream=new ZipOutputStream(response.getOutputStream());
			for (String file:files) {
				if (!new File(filePath+file).exists()) {
					continue;
				}
				instream=new FileInputStream(filePath+file);
				ZipEntry entry = new ZipEntry(file);
				zipstream.putNextEntry(entry);
				byte[] buffer = new byte[1024];
				int len = 0;
				while (len != -1){
					len = instream.read(buffer);
					zipstream.write(buffer,0,buffer.length);
				}
				instream.close();
				zipstream.closeEntry();
				zipstream.flush();
			}
			zipstream.finish();
			zipstream.close();
		} catch (UnsupportedEncodingException e1) {
			logger.error("下载文件出错！",e1);
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		} catch (FileNotFoundException e1) {
			logger.error("下载文件出错！",e1);
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		} catch (IOException e) {
			logger.error("下载文件出错！",e);
			addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
		}
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
