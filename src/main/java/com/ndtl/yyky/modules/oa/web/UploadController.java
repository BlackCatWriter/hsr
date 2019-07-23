package com.ndtl.yyky.modules.oa.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.oa.web.model.FilePath;

@Controller
@RequestMapping(value = "${adminPath}/oa/fileUpload")
public class UploadController extends BaseOAController {

	@RequestMapping(value = { "list", "" })
	public String list(String targetPath, Model model) throws IOException {
		List<FilePath> files = Lists.newArrayList();
		List<FilePath> sortPaths = Lists.newArrayList();
		File root = new File(Global.getUploadFilePath());
		if (StringUtils.isBlank(targetPath)) {
			targetPath = Global.getUploadFilePath();
			sortPaths.add(new FilePath(root.getName(), root.getAbsolutePath()));
		} else {
			File currentFile = new File(targetPath);
			while (!currentFile.equals(root)) {
				files.add(new FilePath(currentFile.getName(), currentFile
						.getAbsolutePath()));
				currentFile = currentFile.getParentFile();
			}
			files.add(new FilePath(root.getName(), root.getAbsolutePath()));
			for (int i = files.size() - 1; i >= 0; i--) {
				FilePath p = files.get(i);
				sortPaths.add(p);
			}
		}
		File dir = new File(targetPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		File[] fs = dir.listFiles();
		model.addAttribute("paths", sortPaths);
		model.addAttribute("currentPath", targetPath);
		model.addAttribute("files", fs);
		return "modules/oa/fileList";
	}

	@RequestMapping(value = { "download" })
	public String download(HttpServletResponse response, String targetPath,
			Model model, String currentPath,
			RedirectAttributes redirectAttributes) {
		if (StringUtils.isBlank(targetPath)) {
			targetPath = Global.getUploadFilePath();
		}
		File file = new File(targetPath);
		if (!file.exists()) {
			addMessage(redirectAttributes, "文件" + targetPath + "不存在！");
		} else {
			String fileName = file.getName();
			try {
				String fName = new String(file.getName().getBytes(),
						"iso-8859-1");
				InputStream inStream = new FileInputStream(
						file.getAbsolutePath());
				response.reset();
				response.setContentType("multipart/form-data");
				response.addHeader("Content-Disposition",
						"attachment; filename=\"" + fName + "\"");
				byte[] b = new byte[100];
				int len;
				while ((len = inStream.read(b)) > 0) {
					response.getOutputStream().write(b, 0, len);
				}
				response.flushBuffer();
				inStream.close();
			} catch (Exception e1) {
				addMessage(redirectAttributes, "下载文件" + fileName + "出错！");
			}
		}
		model.addAttribute("currentPath", currentPath);
		return "redirect:" + Global.getAdminPath()
				+ "/oa/fileUpload/list?targetPath=" + currentPath;
	}

	@RequestMapping(value = { "createFolder" })
	public String createFolder(HttpServletResponse response, String name,
			Model model, String currentPath,
			RedirectAttributes redirectAttributes) {
		try {
			String path = currentPath;
			if (currentPath.endsWith("\\") || currentPath.endsWith("/")) {
				path = currentPath + name;
			} else {
				path = currentPath + "\\" + name;
			}
			File file = new File(path);
			file.mkdirs();
		} catch (Exception e) {
			addMessage(redirectAttributes, "创建文件夹" + name + "出错！");
		}
		model.addAttribute("currentPath", currentPath);
		return "redirect:" + Global.getAdminPath()
				+ "/oa/fileUpload/list?targetPath=" + currentPath;
	}

	@RequestMapping(value = { "delete" })
	public String delete(HttpServletResponse response, String[] fileNames,
			Model model, String currentPath,
			RedirectAttributes redirectAttributes) {
		try {
			for (String fileName : fileNames) {
				File file = new File(fileName);
				if (file.exists()) {
					deleteFile(file);
				}
			}
		} catch (Exception e) {
			addMessage(redirectAttributes, "删除文件出错！");
		}
		model.addAttribute("currentPath", currentPath);
		return "redirect:" + Global.getAdminPath()
				+ "/oa/fileUpload/list?targetPath=" + currentPath;
	}

	@RequestMapping(value = "/upload")
	public String upload(
			@RequestParam(value = "file", required = false) MultipartFile file,
			HttpServletRequest request, String currentPath, ModelMap model) {
		String path = currentPath;
		String fileName = file.getOriginalFilename();
		File targetFile = new File(path, fileName);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		}
		try {
			file.transferTo(targetFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("currentPath", currentPath);
		return "redirect:" + Global.getAdminPath()
				+ "/oa/fileUpload/list?targetPath=" + currentPath;
	}

	@Override
	public BaseOAService getService() {
		return null;
	}

	private void deleteFile(File file) {
		if (file.isFile()) {
			file.delete();
		}
		if (file.isDirectory()) {
			if (file.listFiles().length == 0) {
				file.delete();
			} else {
				for (File f : file.listFiles()) {
					deleteFile(f);
				}
				file.delete();
			}
		}
	}
}
