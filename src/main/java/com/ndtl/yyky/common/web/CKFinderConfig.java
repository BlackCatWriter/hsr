package com.ndtl.yyky.common.web;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;

import com.ckfinder.connector.ServletContextFactory;
import com.ckfinder.connector.configuration.Configuration;
import com.ckfinder.connector.utils.AccessControlUtil;
import com.ndtl.yyky.modules.sys.security.SystemAuthorizingRealm.Principal;

/**
 * CKFinder配置
 */
public class CKFinderConfig extends Configuration {

    public CKFinderConfig(ServletConfig servletConfig) {
        super(servletConfig);
    }

    @Override
    protected Configuration createConfigurationInstance() {
/*        boolean isView = SecurityUtils.getSubject().isPermitted("cms:ckfinder:view");
        boolean isUpload = SecurityUtils.getSubject().isPermitted("cms:ckfinder:upload");
        boolean isEdit = SecurityUtils.getSubject().isPermitted("cms:ckfinder:edit");
        AccessControlLevel alc = this.getAccessConrolLevels().get(0);
        alc.setFolderView(isView);
        alc.setFolderCreate(isEdit);
        alc.setFolderRename(isEdit);
        alc.setFolderDelete(isEdit);
        alc.setFileView(isView);
        alc.setFileUpload(isUpload);
        alc.setFileRename(isEdit);
        alc.setFileDelete(isEdit);*/
         /*for (AccessControlLevel a : this.getAccessConrolLevels()){
         System.out.println(a.getRole()+", "+a.getResourceType()+", "+a.getFolder()
         +", "+a.isFolderView()+", "+a.isFolderCreate()+", "+a.isFolderRename()+", "+a.isFolderDelete()
         +", "+a.isFileView()+", "+a.isFileUpload()+", "+a.isFileRename()+", "+a.isFileDelete());
         }*/
        AccessControlUtil.getInstance(this).loadACLConfig();
        try {
            Principal principal = (Principal) SecurityUtils.getSubject().getPrincipal();
            //this.baseURL = ServletContextFactory.getServletContext().getContextPath() + "/userfiles/" + (principal != null ? principal.getId() : 0) + "/";
            this.baseURL = ServletContextFactory.getServletContext().getContextPath() + "/userfiles/";
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return new CKFinderConfig(this.servletConf);
    }

    @Override
    public boolean checkAuthentication(final HttpServletRequest request) {
        return SecurityUtils.getSubject().getPrincipal() != null;
    }

}
