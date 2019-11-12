package com.ndtl.yyky.modules.cms.web;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.ndtl.yyky.modules.oa.entity.Project;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.beanvalidator.BeanValidators;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.persistence.BaseEntity;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.service.BookService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 栏目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/book")
public class CmsBookController extends BaseOAController {

	@Autowired
	private BookService bookService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("book")
	public Book get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Book) bookService.findOne(id);
		} else {
			return new Book();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap, Book book,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		book.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, book, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(@RequestParam Map<String, Object> paramMap, Book book,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Book> page = bookService.findForCMS(new Page<Book>(request,
				response), book, true, paramMap);
		setUserListInPage(page);
		filterUserAgeInPage(page,paramMap);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/bookList";
	}

	private void setUserListInPage(Page<Book> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Book book = page.getList().get(i);
			setUserListInForm(book);
		}
	}
	private void filterUserAgeInPage(Page<Book> page, Map map) {
		if(StringUtils.isNotEmpty((String)map.get("age"))){
			int age = Integer.valueOf((String)map.get("age"));
			/*for (int i = 0; i < page.getList().size(); i++) {
				Project project = page.getList().get(i);
				if(UserUtils.getUserAgeByUserId(project.getAuthor1()) != age){
					page.getList().remove(i);
				}
			}*/
			Iterator<Book> itr = page.getList().iterator();
			while(itr.hasNext()) {
				if(UserUtils.getUserAgeByUserId(itr.next().getAuthor1()) != age){
					itr.remove();
				}
			}
		}
	}
	private void setUserListInForm(Book book) {
		String strAuthor1 = UserUtils.getDisplayNameForUserList(book
				.getAuthor1());
		String strWeightBelong = UserUtils.getUserDisplayName(book
				.getWeightBelong());
		book.setAuthor1DisplayName(strAuthor1);
		book.setWeightBelongDisplayName(strWeightBelong);
	}

	@RequestMapping(value = "form")
	public String form(Book book, Model model) {
		setUserListInForm(book);
		model.addAttribute("book", book);
		return "modules/cms/bookForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Book book, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "著作数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Book> page = bookService.find(new Page<Book>(request,
					response, -1), book);
			new ExportExcel("著作数据", Book.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/book/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/book/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Book> list = ei.getDataList(Book.class);
			for (Book book : list) {
				try {
					convertOffice(book);
					BeanValidators.validateWithException(validator, book);
					book.setDelFlag(Book.DEL_FLAG_AUDIT);
					bookService.saveBook(book);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>著作 " + book.getTitle() + " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>著作 " + book.getTitle() + " 导入失败："
							+ ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条著作，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条著作"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入著作失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/book/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "checkBookName")
	public String checkBookName(String oldBookName, String bookName) {
		if (bookName != null && bookName.equals(oldBookName)) {
			return "true";
		} else if (bookName != null
				&& bookService.getBookByBookName(bookName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "著作数据导入模板.xlsx";
			new ExportExcel("著作数据", Book.class, 2).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/book/?repage";
	}

	@Override
	public BaseOAService getService() {
		return bookService;
	}

}
