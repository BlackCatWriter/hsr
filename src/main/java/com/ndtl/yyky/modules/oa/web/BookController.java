package com.ndtl.yyky.modules.oa.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.ObjectUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.service.BookService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 论文登记Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/book")
public class BookController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected BookService bookService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 进入申请页
	 * 
	 * @param book
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "form", "" })
	public String form(Book book, Model model) {
		book.setOffice(UserUtils.getUser().getOffice());
		book.setOfficeName(UserUtils.getUser().getOffice().getName());
		model.addAttribute("book", book);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/bookForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param book
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Book book, Model model) {
		setUserListInTask(book);
		model.addAttribute("book", book);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/bookEditForm";
	}
	
	/**
	 * 创建
	 * 
	 * @param book
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Book book) {
			bookService.editBook(book);
			return "redirect:" + Global.getAdminPath() + "/oa/book/form";
	}
	
	@ModelAttribute("book")
	public Book get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Book) bookService.findOne(id);
		} else {
			return new Book();
		}
	}


	/**
	 * 进入重新申请
	 * 
	 * @param id
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "formModify/{id}/{taskId}" })
	public String formModify(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		Book book = (Book) bookService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		book.setVariables(variables);
		setUserListInTask(book);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		model.addAttribute("book", book);
		model.addAttribute("taskId", taskId);
		model.addAttribute("bookId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/bookForm";
	}

	/**
	 * 创建
	 * 
	 * @param book
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Book book, RedirectAttributes redirectAttributes) {
		if(book.getProject()!=null&&book.getProject().getId()==null){
			book.setProject(null);
		}
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = bookService.save(book, variables,
					ProcessDefinitionKey.Book);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/book/form";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param book
	 */
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/bookTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<Book> results = bookService.findTodoTasks(userId,
				ProcessDefinitionKey.Book);
		mav.addObject("book", results);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" })
	public String list(Book book, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Book> page = bookService.find(new Page<Book>(request, response),
				book);
		model.addAttribute("page", page);
		return "modules/oa/bookList";
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "selflist" })
	public String selfList(Book book, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Book> page = bookService.findForSelf(new Page<Book>(request,
				response), book);
		model.addAttribute("page", page);
		return "modules/oa/bookList";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getBook(@PathVariable("id") Long id) {
		Book book = (Book) bookService.findOne(id);
		setUserListInTask(book);
		if (book.getVariables().get("officeName") != null) {
			Long officeID = Long.valueOf(book.getVariables().get("officeName")
					.toString());
			Office office = officeService.get(officeID);
			book.setOfficeName(office.getName());
			book.setOffice(office);
			bookService.saveBook(book);
		} else {
			book.setOfficeName(book.getOffice().getName());
		}
		return JsonMapper.getInstance().toJson(book);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getBookWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Book book = (Book) bookService.findOne(id);
		setUserListInTask(book);
		Map<String, Object> variables = taskService.getVariables(taskId);
		book.setVariables(variables);
		book.setOfficeName(book.getOffice().getName());
		return JsonMapper.getInstance().toJson(book);
	}

	/**
	 * 完成任务
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "complete/{id}", method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public String complete(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			bookService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete bookId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	// ajax methods
	@ResponseBody
	@RequestMapping(value = "checkTitle")
	public String checkTitle(String oldTitle, String title) {
		if (title != null && title.equals(oldTitle)) {
			return "true";
		} else if (title != null
				&& bookService.getBookByBookName(title) == null) {
			return "true";
		}
		return "false";
	}

	@Override
	public BaseOAService getService() {
		return bookService;
	}

	private void setUserListInTask(Book book) {
		String strAuthor1 = UserUtils.getDisplayNameForUserList(book
				.getAuthor1());
		String strWeightBelong = UserUtils.getUserDisplayName(book
				.getWeightBelong());
		book.setAuthor1DisplayName(strAuthor1);
		book.setWeightBelongDisplayName(strWeightBelong);
	}
}
