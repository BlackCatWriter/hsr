package com.ndtl.yyky.modules.oa.web;

import java.util.List;

import com.ndtl.yyky.modules.oa.entity.*;
import com.ndtl.yyky.modules.oa.service.*;
import org.activiti.engine.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.entity.Article;
import com.ndtl.yyky.modules.cms.service.ArticleService;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.oa.service.base.BasicTaskService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.web.model.DashboardModel;
import com.ndtl.yyky.modules.oa.web.model.UserTask;
import com.ndtl.yyky.modules.oa.web.model.converter.UserTaskConverter;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 论文登记Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/dashboard")
public class DashBoardController extends BaseController {

	@Autowired
	protected BasicTaskService basicTaskService;

	@Autowired
	protected ThesisService thesisService;
	@Autowired
	protected ProjectService projectService;
	@Autowired
	protected BookService bookService;
	@Autowired
	protected PatentService patentService;
	@Autowired
	protected RewardService rewardService;
	@Autowired
	protected ArticleService articleService;
	@Autowired
	protected AcadService acadService;
	@Autowired
	protected AcademicService academicService;
	@Autowired
	protected AcademiccostService academiccostService;
	@Autowired
	protected AdvstudyService advstudyService;
	@Autowired
	protected ExpenseService expenseService;
	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	@Autowired
	protected ProjectToUserService projectToUserService;

	@Autowired
	protected RewardToUserService rewardToUserService;

	@SuppressWarnings("unchecked")
	@RequestMapping(value = { "form", "" })
	public String form(Model model) {
		User user = UserUtils.getUser();
		DashboardModel dm = new DashboardModel();
		// init notice
		List<Article> notices = articleService.findAll();
		dm.setNotices(notices);
		// init tasks
		List<UserTask> tasks = Lists.newArrayList();
		List<Thesis> thesises = thesisService.findTodoTasks(user.getId()
				.toString(), ProcessDefinitionKey.Thesis);
		tasks.addAll(UserTaskConverter.convert(thesises));
		List<Project> projects = (List<Project>) projectService.findTodoTasks(
				user.getId().toString(), ProcessDefinitionKey.Project);
		tasks.addAll(UserTaskConverter.convert(projects));

		List<Book> books = bookService.findTodoTasks(user.getId().toString(),
				ProcessDefinitionKey.Book);
		tasks.addAll(UserTaskConverter.convert(books));

		List<Patent> patents = patentService.findTodoTasks(user.getId()
				.toString(), ProcessDefinitionKey.Patent);
		tasks.addAll(UserTaskConverter.convert(patents));

		List<Reward> rewards = (List<Reward>) rewardService.findTodoTasks(user
				.getId().toString(), ProcessDefinitionKey.Reward);
		tasks.addAll(UserTaskConverter.convert(rewards));

		List<Project> auditProjects = (List<Project>) projectService
				.findAuditProjects(user.getId());
		tasks.addAll(UserTaskConverter.convert(auditProjects, true));

		List<ProjectToUser> projectsToUses = (List<ProjectToUser>) projectToUserService
				.findByUserId(user.getId());
		for (ProjectToUser projectsToUse : projectsToUses) {
			UserTask ut = UserTaskConverter
					.convert((BaseOAEntity) projectsToUse.getProject());
			ut.setType("项目评审");
			tasks.add(ut);
		}

		List<RewardToUser> rewardToUsers = (List<RewardToUser>) rewardToUserService
				.findByUserId(user.getId());
		for (RewardToUser rewardToUser : rewardToUsers) {
			UserTask ut = UserTaskConverter.convert((BaseOAEntity) rewardToUser
					.getReward());
			ut.setType("奖项评审");
			tasks.add(ut);
		}

		List<Academic> academic = (List<Academic>) academicService
				.findTodoTasks(user.getId().toString(),
						ProcessDefinitionKey.Academic);
		tasks.addAll(UserTaskConverter.convert(academic));

		List<Advstudy> advstudy = (List<Advstudy>) advstudyService
				.findTodoTasks(user.getId().toString(),
						ProcessDefinitionKey.Advstudy);
		tasks.addAll(UserTaskConverter.convert(advstudy));

		List<Acad> acad = (List<Acad>) acadService.findTodoTasks(user.getId()
				.toString(), ProcessDefinitionKey.Acad);
		tasks.addAll(UserTaskConverter.convert(acad));

		List<Acad> putoffAcads = (List<Acad>) acadService
				.findOwnedContinuedAcad(user.getId());
		tasks.addAll(UserTaskConverter.convertAcadputoff(putoffAcads));

		List<Academiccost> academiccosts = (List<Academiccost>) academiccostService
				.findTodoTasks(user.getId().toString(),
						ProcessDefinitionKey.Academiccost);
		tasks.addAll(UserTaskConverter.convert(academiccosts));

		List<Expense> expense = (List<Expense>) expenseService
				.findTodoTasks(user.getId().toString(),
						ProcessDefinitionKey.Expense);
		tasks.addAll(UserTaskConverter.convert(expense));

		dm.setTasks(tasks);

		// init owned tasks
		List<UserTask> ownedTasks = Lists.newArrayList();
		List<Thesis> ownedThesises = (List<Thesis>) thesisService
				.findOwnedTasks(user.getId());
		ownedTasks.addAll(UserTaskConverter.convert(ownedThesises));
		List<Project> ownedProjects = (List<Project>) projectService
				.findOwnedTasks(user.getId());
		ownedTasks.addAll(UserTaskConverter.convert(ownedProjects));

		List<Book> ownedBooks = (List<Book>) bookService.findOwnedTasks(user
				.getId());
		ownedTasks.addAll(UserTaskConverter.convert(ownedBooks));

		List<Patent> ownedPatents = (List<Patent>) patentService
				.findOwnedTasks(user.getId());
		ownedTasks.addAll(UserTaskConverter.convert(ownedPatents));

		List<Reward> ownedRewards = (List<Reward>) rewardService
				.findOwnedTasks(user.getId());
		ownedTasks.addAll(UserTaskConverter.convert(ownedRewards));

		dm.setOwnedTasks(ownedTasks);
		model.addAttribute("dashboardModel", dm);
		return "modules/oa/dashboard";
	}
}
