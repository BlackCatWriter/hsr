package com.ndtl.yyky.common.utils.excel;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class ColumnTitleMap {
    private static LinkedHashMap<String, String> columnTitleMap = new LinkedHashMap<String, String>();
    private ArrayList<String> titleKeyList = new ArrayList<String> ();

    public ColumnTitleMap(String datatype) {
        switch (datatype) {
            case "projectYearAccount":
                initProjectYearAccountColu();
                break;
            case "otherAccountDetail":
                initOtherAccountDetailColu();
                break;
            case "expertReviewDetail":
                initExpertReviewDetailColu();
                break;
            case "subjectRewardDetail":
                initSubjectRewardDetailColu();
                break;
            default:
                break;
        }

    }
    /**
     * 项目年度结算
     */
    private void initProjectYearAccountColu() {
        columnTitleMap.put("project_no", "立项号");
        columnTitleMap.put("project_name", "项目名称");
        columnTitleMap.put("budget", "课题总计预算");
        columnTitleMap.put("expend", "课题累计支出");
        columnTitleMap.put("balance", "经费余额");
        columnTitleMap.put("year", "年度");
    }
    /**
     * 其它经费报销明细
     */
    private void initOtherAccountDetailColu() {
        columnTitleMap.put("name", "姓名");
        columnTitleMap.put("dept_name", "所属科室");
        columnTitleMap.put("topic", "学术主题");
        columnTitleMap.put("bx_fee", "报销金额");
        columnTitleMap.put("update_date", "报销时间");
        columnTitleMap.put("remarks", "备注");
    }
    /**
     * 专家评审明细
     */
    private void initExpertReviewDetailColu() {
        columnTitleMap.put("dept_name", "所属科室");
        columnTitleMap.put("name", "专家名称");
        columnTitleMap.put("project_name", "项目名称");
        columnTitleMap.put("creativity", "创新性");
        columnTitleMap.put("advancement", "先进性");
        columnTitleMap.put("scientificity", "科学性");
        columnTitleMap.put("feasibility", "可行性");
        columnTitleMap.put("practicability", "实用性");
        columnTitleMap.put("update_date", "评审时间");
        columnTitleMap.put("remarks", "备注");
    }/**
     * 各科奖励明细
     */
    private void initSubjectRewardDetailColu() {
        columnTitleMap.put("name", "姓名");
        columnTitleMap.put("dept_name", "所属科室");
        columnTitleMap.put("project_name", "关联项目");
        columnTitleMap.put("jl", "奖励金额");
        columnTitleMap.put("title", "相关研究性课题");
        columnTitleMap.put("update_date", "申请时间");
    }


    public Map<String, String> getColumnTitleMap() {
        return columnTitleMap;
    }

    public ArrayList<String> getTitleKeyList() {
        return titleKeyList;
    }
    public static void main(String[] args) {
        System.out.println(columnTitleMap);

    }
}
