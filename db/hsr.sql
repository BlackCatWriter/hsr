/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.6.24-enterprise-commercial-advanced : Database - hsr
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`hsr` /*!40100 DEFAULT CHARACTER SET utf8 */;

/*Table structure for table `act_ge_bytearray` */

CREATE TABLE `act_ge_bytearray` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BYTES_` longblob,
  `GENERATED_` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_BYTEARR_DEPL` (`DEPLOYMENT_ID_`),
  CONSTRAINT `ACT_FK_BYTEARR_DEPL` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


/*Table structure for table `act_ge_property` */

CREATE TABLE `act_ge_property` (
  `NAME_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `VALUE_` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int(11) DEFAULT NULL,
  PRIMARY KEY (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ge_property` */

insert  into `act_ge_property`(`NAME_`,`VALUE_`,`REV_`) values ('next.dbid','63701',638);
insert  into `act_ge_property`(`NAME_`,`VALUE_`,`REV_`) values ('schema.history','create(5.12)',1);
insert  into `act_ge_property`(`NAME_`,`VALUE_`,`REV_`) values ('schema.version','5.12',1);

/*Table structure for table `act_hi_actinst` */

CREATE TABLE `act_hi_actinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8_bin NOT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `CALL_PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACT_NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ACT_TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `ASSIGNEE_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_ACT_INST_START` (`START_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_ACT_INST_PROCINST` (`PROC_INST_ID_`,`ACT_ID_`),
  KEY `ACT_IDX_HI_ACT_INST_EXEC` (`EXECUTION_ID_`,`ACT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_actinst` */

/*Table structure for table `act_hi_attachment` */

CREATE TABLE `act_hi_attachment` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `URL_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `CONTENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_attachment` */

/*Table structure for table `act_hi_comment` */

CREATE TABLE `act_hi_comment` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TIME_` datetime NOT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACTION_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `MESSAGE_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `FULL_MSG_` longblob,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_comment` */

/*Table structure for table `act_hi_detail` */

CREATE TABLE `act_hi_detail` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACT_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin NOT NULL,
  `VAR_TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int(11) DEFAULT NULL,
  `TIME_` datetime NOT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint(20) DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_DETAIL_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_ACT_INST` (`ACT_INST_ID_`),
  KEY `ACT_IDX_HI_DETAIL_TIME` (`TIME_`),
  KEY `ACT_IDX_HI_DETAIL_NAME` (`NAME_`),
  KEY `ACT_IDX_HI_DETAIL_TASK_ID` (`TASK_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_detail` */

/*Table structure for table `act_hi_procinst` */

CREATE TABLE `act_hi_procinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `START_TIME_` datetime NOT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint(20) DEFAULT NULL,
  `START_USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `START_ACT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `END_ACT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `SUPER_PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `PROC_INST_ID_` (`PROC_INST_ID_`),
  UNIQUE KEY `ACT_UNIQ_HI_BUS_KEY` (`PROC_DEF_ID_`,`BUSINESS_KEY_`),
  KEY `ACT_IDX_HI_PRO_INST_END` (`END_TIME_`),
  KEY `ACT_IDX_HI_PRO_I_BUSKEY` (`BUSINESS_KEY_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_procinst` */

/*Table structure for table `act_hi_taskinst` */

CREATE TABLE `act_hi_taskinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `START_TIME_` datetime NOT NULL,
  `CLAIM_TIME_` datetime DEFAULT NULL,
  `END_TIME_` datetime DEFAULT NULL,
  `DURATION_` bigint(20) DEFAULT NULL,
  `DELETE_REASON_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `PRIORITY_` int(11) DEFAULT NULL,
  `DUE_DATE_` datetime DEFAULT NULL,
  `FORM_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_taskinst` */

/*Table structure for table `act_hi_varinst` */

CREATE TABLE `act_hi_varinst` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin NOT NULL,
  `VAR_TYPE_` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int(11) DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint(20) DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_HI_PROCVAR_PROC_INST` (`PROC_INST_ID_`),
  KEY `ACT_IDX_HI_PROCVAR_NAME_TYPE` (`NAME_`,`VAR_TYPE_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_hi_varinst` */

/*Table structure for table `act_id_group` */

CREATE TABLE `act_id_group` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_id_group` */

insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('departmentLeader',7,'科室主任','assignment');
insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('financeDept',11,'财务处人员','assignment');
insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('hosLeader',8,'医院领导','assignment');
insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('kjDept',12,'科教处人员','assignment');
insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('kjDeptLeader',3,'科教处人员','assignment');
insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('sys_admin',8,'系统管理员','security-role');
insert  into `act_id_group`(`ID_`,`REV_`,`NAME_`,`TYPE_`) values ('user',10,'普通人员','user');

/*Table structure for table `act_id_info` */

CREATE TABLE `act_id_info` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `USER_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `VALUE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PASSWORD_` longblob,
  `PARENT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_id_info` */

/*Table structure for table `act_id_membership` */

CREATE TABLE `act_id_membership` (
  `USER_ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `GROUP_ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`USER_ID_`,`GROUP_ID_`),
  KEY `ACT_FK_MEMB_GROUP` (`GROUP_ID_`),
  CONSTRAINT `ACT_FK_MEMB_GROUP` FOREIGN KEY (`GROUP_ID_`) REFERENCES `act_id_group` (`ID_`),
  CONSTRAINT `ACT_FK_MEMB_USER` FOREIGN KEY (`USER_ID_`) REFERENCES `act_id_user` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_id_membership` */

insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('1','departmentLeader');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10449','departmentLeader');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('1','financeDept');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10408','financeDept');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('1','hosLeader');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10448','hosLeader');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('1','kjDept');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10223','kjDept');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('11471','kjDept');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('1','sys_admin');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('1','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10000','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10001','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10002','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10003','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10004','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10005','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10006','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10007','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10008','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10009','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10223','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10408','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10448','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('10449','user');
insert  into `act_id_membership`(`USER_ID_`,`GROUP_ID_`) values ('11471','user');


/*Table structure for table `act_id_user` */

CREATE TABLE `act_id_user` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `FIRST_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `LAST_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `EMAIL_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PWD_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PICTURE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_id_user` */

insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('1',25,'admin','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10000',1,'普十','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10001',1,'普九','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10002',1,'普八','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10003',1,'普七','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10004',1,'普六','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10005',1,'普五','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10006',1,'普四','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10007',1,'普三','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10008',1,'普二','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10009',1,'普一','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10223',16,'科教二','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10408',6,'财务处','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10448',8,'院领导','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('10449',7,'科主任','','','',NULL);
insert  into `act_id_user`(`ID_`,`REV_`,`FIRST_`,`LAST_`,`EMAIL_`,`PWD_`,`PICTURE_ID_`) values ('11471',4,'科教一','','','',NULL);


/*Table structure for table `act_re_deployment` */

CREATE TABLE `act_re_deployment` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DEPLOY_TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


/*Table structure for table `act_re_model` */

CREATE TABLE `act_re_model` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATE_TIME_` timestamp NULL DEFAULT NULL,
  `LAST_UPDATE_TIME_` timestamp NULL DEFAULT NULL,
  `VERSION_` int(11) DEFAULT NULL,
  `META_INFO_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EDITOR_SOURCE_VALUE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EDITOR_SOURCE_EXTRA_VALUE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_MODEL_SOURCE` (`EDITOR_SOURCE_VALUE_ID_`),
  KEY `ACT_FK_MODEL_SOURCE_EXTRA` (`EDITOR_SOURCE_EXTRA_VALUE_ID_`),
  KEY `ACT_FK_MODEL_DEPLOYMENT` (`DEPLOYMENT_ID_`),
  CONSTRAINT `ACT_FK_MODEL_DEPLOYMENT` FOREIGN KEY (`DEPLOYMENT_ID_`) REFERENCES `act_re_deployment` (`ID_`),
  CONSTRAINT `ACT_FK_MODEL_SOURCE` FOREIGN KEY (`EDITOR_SOURCE_VALUE_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_MODEL_SOURCE_EXTRA` FOREIGN KEY (`EDITOR_SOURCE_EXTRA_VALUE_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_re_model` */

/*Table structure for table `act_re_procdef` */

CREATE TABLE `act_re_procdef` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `CATEGORY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `KEY_` varchar(255) COLLATE utf8_bin NOT NULL,
  `VERSION_` int(11) NOT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `RESOURCE_NAME_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DGRM_RESOURCE_NAME_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `HAS_START_FORM_KEY_` tinyint(4) DEFAULT NULL,
  `SUSPENSION_STATE_` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_PROCDEF` (`KEY_`,`VERSION_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


/*Table structure for table `act_ru_event_subscr` */

CREATE TABLE `act_ru_event_subscr` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `EVENT_TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `EVENT_NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACTIVITY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `CONFIGURATION_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATED_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_EVENT_SUBSCR_CONFIG_` (`CONFIGURATION_`),
  KEY `ACT_FK_EVENT_EXEC` (`EXECUTION_ID_`),
  CONSTRAINT `ACT_FK_EVENT_EXEC` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ru_event_subscr` */

/*Table structure for table `act_ru_execution` */

CREATE TABLE `act_ru_execution` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BUSINESS_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PARENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `SUPER_EXEC_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ACT_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `IS_ACTIVE_` tinyint(4) DEFAULT NULL,
  `IS_CONCURRENT_` tinyint(4) DEFAULT NULL,
  `IS_SCOPE_` tinyint(4) DEFAULT NULL,
  `IS_EVENT_SCOPE_` tinyint(4) DEFAULT NULL,
  `SUSPENSION_STATE_` int(11) DEFAULT NULL,
  `CACHED_ENT_STATE_` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_UNIQ_RU_BUS_KEY` (`PROC_DEF_ID_`,`BUSINESS_KEY_`),
  KEY `ACT_IDX_EXEC_BUSKEY` (`BUSINESS_KEY_`),
  KEY `ACT_FK_EXE_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_EXE_PARENT` (`PARENT_ID_`),
  KEY `ACT_FK_EXE_SUPER` (`SUPER_EXEC_`),
  CONSTRAINT `ACT_FK_EXE_PARENT` FOREIGN KEY (`PARENT_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_EXE_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_EXE_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ACT_FK_EXE_SUPER` FOREIGN KEY (`SUPER_EXEC_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ru_execution` */

/*Table structure for table `act_ru_identitylink` */

CREATE TABLE `act_ru_identitylink` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `GROUP_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `USER_ID_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_IDENT_LNK_USER` (`USER_ID_`),
  KEY `ACT_IDX_IDENT_LNK_GROUP` (`GROUP_ID_`),
  KEY `ACT_IDX_ATHRZ_PROCEDEF` (`PROC_DEF_ID_`),
  KEY `ACT_FK_TSKASS_TASK` (`TASK_ID_`),
  KEY `ACT_FK_IDL_PROCINST` (`PROC_INST_ID_`),
  CONSTRAINT `ACT_FK_ATHRZ_PROCEDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_IDL_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TSKASS_TASK` FOREIGN KEY (`TASK_ID_`) REFERENCES `act_ru_task` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ru_identitylink` */

/*Table structure for table `act_ru_job` */

CREATE TABLE `act_ru_job` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `LOCK_EXP_TIME_` timestamp NULL DEFAULT NULL,
  `LOCK_OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `EXCLUSIVE_` tinyint(1) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROCESS_INSTANCE_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `RETRIES_` int(11) DEFAULT NULL,
  `EXCEPTION_STACK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `EXCEPTION_MSG_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `DUEDATE_` timestamp NULL DEFAULT NULL,
  `REPEAT_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `HANDLER_TYPE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `HANDLER_CFG_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_FK_JOB_EXCEPTION` (`EXCEPTION_STACK_ID_`),
  CONSTRAINT `ACT_FK_JOB_EXCEPTION` FOREIGN KEY (`EXCEPTION_STACK_ID_`) REFERENCES `act_ge_bytearray` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ru_job` */

/*Table structure for table `act_ru_task` */

CREATE TABLE `act_ru_task` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `REV_` int(11) DEFAULT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_DEF_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PARENT_TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TASK_DEF_KEY_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `OWNER_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ASSIGNEE_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DELEGATION_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PRIORITY_` int(11) DEFAULT NULL,
  `CREATE_TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DUE_DATE_` datetime DEFAULT NULL,
  `SUSPENSION_STATE_` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_TASK_CREATE` (`CREATE_TIME_`),
  KEY `ACT_FK_TASK_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_TASK_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_TASK_PROCDEF` (`PROC_DEF_ID_`),
  CONSTRAINT `ACT_FK_TASK_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_PROCDEF` FOREIGN KEY (`PROC_DEF_ID_`) REFERENCES `act_re_procdef` (`ID_`),
  CONSTRAINT `ACT_FK_TASK_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ru_task` */

/*Table structure for table `act_ru_variable` */

CREATE TABLE `act_ru_variable` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int(11) DEFAULT NULL,
  `TYPE_` varchar(255) COLLATE utf8_bin NOT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin NOT NULL,
  `EXECUTION_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `PROC_INST_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `TASK_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BYTEARRAY_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `DOUBLE_` double DEFAULT NULL,
  `LONG_` bigint(20) DEFAULT NULL,
  `TEXT_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `TEXT2_` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  KEY `ACT_IDX_VARIABLE_TASK_ID` (`TASK_ID_`),
  KEY `ACT_FK_VAR_EXE` (`EXECUTION_ID_`),
  KEY `ACT_FK_VAR_PROCINST` (`PROC_INST_ID_`),
  KEY `ACT_FK_VAR_BYTEARRAY` (`BYTEARRAY_ID_`),
  CONSTRAINT `ACT_FK_VAR_BYTEARRAY` FOREIGN KEY (`BYTEARRAY_ID_`) REFERENCES `act_ge_bytearray` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_EXE` FOREIGN KEY (`EXECUTION_ID_`) REFERENCES `act_ru_execution` (`ID_`),
  CONSTRAINT `ACT_FK_VAR_PROCINST` FOREIGN KEY (`PROC_INST_ID_`) REFERENCES `act_ru_execution` (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `act_ru_variable` */

/*Table structure for table `cms_article` */

CREATE TABLE `cms_article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `category_id` bigint(20) DEFAULT NULL COMMENT '栏目编号',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `color` varchar(50) DEFAULT NULL COMMENT '标题颜色（red：红色；green：绿色；blue：蓝色；yellow：黄色；orange：橙色）',
  `image` varchar(255) DEFAULT NULL COMMENT '文章图片',
  `keywords` varchar(255) DEFAULT NULL COMMENT '关键字',
  `description` varchar(255) DEFAULT NULL COMMENT '描述、摘要',
  `weight` int(11) DEFAULT '0' COMMENT '权重，越大越靠前',
  `weight_date` datetime DEFAULT NULL COMMENT '权重期限，过期后将权重设置为：0',
  `hits` int(11) DEFAULT '0' COMMENT '点击数',
  `posid` varchar(10) DEFAULT NULL COMMENT '推荐位，多选（1：首页焦点图；2：栏目页文章推荐；）',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `cms_article_create_by` (`create_by`),
  KEY `cms_article_title` (`title`),
  KEY `cms_article_keywords` (`keywords`),
  KEY `cms_article_del_flag` (`del_flag`),
  KEY `cms_article_weight` (`weight`),
  KEY `cms_article_update_date` (`update_date`),
  KEY `cms_article_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

/*Data for the table `cms_article` */

/*Table structure for table `cms_article_data` */

CREATE TABLE `cms_article_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `content` text COMMENT '文章内容',
  `copyfrom` varchar(255) DEFAULT NULL COMMENT '文章来源',
  `relation` varchar(255) DEFAULT NULL COMMENT '相关文章',
  `allow_comment` char(1) DEFAULT NULL COMMENT '是否允许评论',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章详表';

/*Data for the table `cms_article_data` */

/*Table structure for table `cms_category` */

CREATE TABLE `cms_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `site_id` bigint(20) DEFAULT '1' COMMENT '站点编号',
  `office_id` bigint(20) DEFAULT NULL COMMENT '归属机构',
  `parent_id` bigint(20) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(255) NOT NULL COMMENT '所有父级编号',
  `module` varchar(20) DEFAULT NULL COMMENT '栏目模块（article：文章；picture：图片；download：下载；link：链接；special：专题）',
  `name` varchar(100) NOT NULL COMMENT '栏目名称',
  `image` varchar(255) DEFAULT NULL COMMENT '栏目图片',
  `href` varchar(255) DEFAULT NULL COMMENT '链接',
  `target` varchar(20) DEFAULT NULL COMMENT '目标（ _blank、_self、_parent、_top）',
  `description` varchar(255) DEFAULT NULL COMMENT '描述，填写有助于搜索引擎优化',
  `keywords` varchar(255) DEFAULT NULL COMMENT '关键字，填写有助于搜索引擎优化',
  `sort` int(11) DEFAULT '30' COMMENT '排序（升序）',
  `in_menu` char(1) DEFAULT '1' COMMENT '是否在导航中显示（1：显示；0：不显示）',
  `in_list` char(1) DEFAULT '1' COMMENT '是否在分类页中显示列表（1：显示；0：不显示）',
  `show_modes` char(1) DEFAULT '0' COMMENT '展现方式（0:有子栏目显示栏目列表，无子栏目显示内容列表;1：首栏目内容列表；2：栏目第一条内容）',
  `allow_comment` char(1) DEFAULT NULL COMMENT '是否允许评论',
  `is_audit` char(1) DEFAULT NULL COMMENT '是否需要审核',
  `custom_list_view` varchar(255) DEFAULT NULL COMMENT '自定义列表视图',
  `custom_content_view` varchar(255) DEFAULT NULL COMMENT '自定义内容视图',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `cms_category_parent_id` (`parent_id`),
  KEY `cms_category_parent_ids` (`parent_ids`),
  KEY `cms_category_module` (`module`),
  KEY `cms_category_name` (`name`),
  KEY `cms_category_sort` (`sort`),
  KEY `cms_category_del_flag` (`del_flag`),
  KEY `cms_category_office_id` (`office_id`),
  KEY `cms_category_site_id` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='栏目表';

/*Data for the table `cms_category` */

insert  into `cms_category`(`id`,`site_id`,`office_id`,`parent_id`,`parent_ids`,`module`,`name`,`image`,`href`,`target`,`description`,`keywords`,`sort`,`in_menu`,`in_list`,`show_modes`,`allow_comment`,`is_audit`,`custom_list_view`,`custom_content_view`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,0,1,0,'0,',NULL,'顶级栏目',NULL,NULL,NULL,NULL,NULL,0,'1','1','0','0','1',NULL,NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `cms_category`(`id`,`site_id`,`office_id`,`parent_id`,`parent_ids`,`module`,`name`,`image`,`href`,`target`,`description`,`keywords`,`sort`,`in_menu`,`in_list`,`show_modes`,`allow_comment`,`is_audit`,`custom_list_view`,`custom_content_view`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (2,1,1,1,'0,1,','article','论文管理','','','','','',10,'1','1','0','0','1','','',1,'2013-05-27 08:00:00',1,'2015-04-01 14:14:54',NULL,'0');

/*Table structure for table `cms_comment` */

CREATE TABLE `cms_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `category_id` bigint(20) NOT NULL COMMENT '栏目编号',
  `content_id` bigint(20) NOT NULL COMMENT '栏目内容的编号（Article.id、Photo.id、Download.id）',
  `title` varchar(255) DEFAULT NULL COMMENT '栏目内容的标题（Article.title、Photo.title、Download.title）',
  `content` varchar(255) DEFAULT NULL COMMENT '评论内容',
  `name` varchar(100) DEFAULT NULL COMMENT '评论姓名',
  `ip` varchar(100) DEFAULT NULL COMMENT '评论IP',
  `create_date` datetime NOT NULL COMMENT '评论时间',
  `audit_user_id` bigint(20) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '审核时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `cms_comment_category_id` (`category_id`),
  KEY `cms_comment_content_id` (`content_id`),
  KEY `cms_comment_status` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论表';

/*Data for the table `cms_comment` */

/*Table structure for table `cms_guestbook` */

CREATE TABLE `cms_guestbook` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` char(1) NOT NULL COMMENT '留言分类（1咨询、2建议、3投诉、4其它）',
  `content` varchar(255) NOT NULL COMMENT '留言内容',
  `name` varchar(100) NOT NULL COMMENT '姓名',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `phone` varchar(100) NOT NULL COMMENT '电话',
  `workunit` varchar(100) NOT NULL COMMENT '单位',
  `ip` varchar(100) NOT NULL COMMENT 'IP',
  `create_date` datetime NOT NULL COMMENT '留言时间',
  `re_user_id` bigint(20) DEFAULT NULL COMMENT '回复人',
  `re_date` datetime DEFAULT NULL COMMENT '回复时间',
  `re_content` varchar(100) DEFAULT NULL COMMENT '回复内容',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `cms_guestbook_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='留言板';

/*Data for the table `cms_guestbook` */

/*Table structure for table `cms_link` */

CREATE TABLE `cms_link` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `category_id` bigint(20) NOT NULL COMMENT '栏目编号',
  `title` varchar(255) NOT NULL COMMENT '链接名称',
  `color` varchar(50) DEFAULT NULL COMMENT '标题颜色（red：红色；green：绿色；blue：蓝色；yellow：黄色；orange：橙色）',
  `image` varchar(255) DEFAULT NULL COMMENT '链接图片，如果上传了图片，则显示为图片链接',
  `href` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `weight` int(11) DEFAULT '0' COMMENT '权重，越大越靠前',
  `weight_date` datetime DEFAULT NULL COMMENT '权重期限，过期后将权重设置为：0',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `cms_link_category_id` (`category_id`),
  KEY `cms_link_title` (`title`),
  KEY `cms_link_del_flag` (`del_flag`),
  KEY `cms_link_weight` (`weight`),
  KEY `cms_link_create_by` (`create_by`),
  KEY `cms_link_update_date` (`update_date`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='友情链接';

/*Data for the table `cms_link` */

insert  into `cms_link`(`id`,`category_id`,`title`,`color`,`image`,`href`,`weight`,`weight_date`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (10,22,'江苏省医学会','','','http://www.jsma.net.cn/',0,NULL,1,'2013-05-27 08:00:00',1,'2015-04-01 14:33:52','','0');
insert  into `cms_link`(`id`,`category_id`,`title`,`color`,`image`,`href`,`weight`,`weight_date`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (12,23,'江苏省人民医院科研管理系统','','','http://kygl.jsphto.com/',0,NULL,1,'2013-05-27 08:00:00',1,'2015-04-01 14:38:24','','0');

/*Table structure for table `cms_site` */

CREATE TABLE `cms_site` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) NOT NULL COMMENT '站点名称',
  `title` varchar(100) NOT NULL COMMENT '站点标题',
  `logo` varchar(255) DEFAULT NULL COMMENT '站点Logo',
  `domain` varchar(255) DEFAULT NULL COMMENT '站点域名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述，填写有助于搜索引擎优化',
  `keywords` varchar(255) DEFAULT NULL COMMENT '关键字，填写有助于搜索引擎优化',
  `theme` varchar(255) DEFAULT 'default' COMMENT '主题',
  `copyright` text COMMENT '版权信息',
  `custom_index_view` varchar(255) DEFAULT NULL COMMENT '自定义站点首页视图',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `cms_site_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='站点表';

/*Data for the table `cms_site` */

insert  into `cms_site`(`id`,`name`,`title`,`logo`,`domain`,`description`,`keywords`,`theme`,`copyright`,`custom_index_view`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,'医院科研管理系统','医院科研管理系统',NULL,NULL,'hsr','hsr','basic','Copyright &copy; 2015  - Powered By NDTL V1.0',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');

/*Table structure for table `oa_acad` */

CREATE TABLE `oa_acad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acad_name` varchar(45) DEFAULT NULL,
  `exercise_role` varchar(45) DEFAULT NULL,
  `level` varchar(10) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `is_finished` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_acad` */

/*Table structure for table `oa_academic` */

CREATE TABLE `oa_academic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `academic_name` varchar(45) DEFAULT NULL,
  `exercise_role` varchar(45) DEFAULT NULL,
  `place` varchar(45) DEFAULT NULL,
  `host_unit` varchar(45) DEFAULT NULL,
  `level` varchar(10) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `used` tinyint(2) DEFAULT NULL,
  `academiccost_id` int(11) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_academic` */

/*Table structure for table `oa_academiccost` */

CREATE TABLE `oa_academiccost` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bx_fee` varchar(45) DEFAULT NULL,
  `used_type` tinyint(2) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `create_by` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `del_flag` char(1) NOT NULL DEFAULT '0',
  `academic_id` int(11) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `advstudy_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_academiccost` */

/*Table structure for table `oa_achievement` */

CREATE TABLE `oa_achievement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `major` varchar(45) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `award_level` char(4) DEFAULT NULL,
  `jl_level` char(4) DEFAULT NULL,
  `author1` varchar(100) DEFAULT NULL,
  `author2` varchar(100) DEFAULT NULL,
  `author3` varchar(100) DEFAULT NULL,
  `other_authors` varchar(100) DEFAULT NULL,
  `jl` varchar(45) DEFAULT NULL,
  `yjl` varchar(45) DEFAULT NULL,
  `weight_belong` int(11) DEFAULT NULL,
  `create_by` bigint(20) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` bigint(20) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `del_flag` char(1) NOT NULL DEFAULT '0',
  `weight` varchar(45) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `project_name` varchar(100) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_achievement` */

/*Table structure for table `oa_advstudy` */

CREATE TABLE `oa_advstudy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bx_fee` varchar(45) DEFAULT NULL,
  `advstudy_direction` varchar(45) DEFAULT NULL,
  `host_unit` varchar(45) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `academiccost_id` int(11) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_advstudy` */

/*Table structure for table `oa_book` */

CREATE TABLE `oa_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author1` varchar(255) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `title` varchar(1024) DEFAULT NULL,
  `time` varchar(100) DEFAULT NULL,
  `number` varchar(100) DEFAULT NULL,
  `jl` varchar(45) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `category` char(4) DEFAULT NULL,
  `weight` varchar(45) DEFAULT NULL,
  `weight_belong` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `letters` int(11) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_book` */

/*Table structure for table `oa_expense` */

CREATE TABLE `oa_expense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `expense_type` varchar(20) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `create_by` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `del_flag` char(1) NOT NULL DEFAULT '0',
  `project_id` int(11) DEFAULT NULL,
  `person` varchar(100) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_expense` */

/*Table structure for table `oa_leave` */

CREATE TABLE `oa_leave` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `process_instance_id` varchar(64) DEFAULT NULL COMMENT '流程实例编号',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `leave_type` varchar(20) DEFAULT NULL COMMENT '请假类型',
  `reason` varchar(255) DEFAULT NULL COMMENT '请假理由',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  `reality_start_time` datetime DEFAULT NULL COMMENT '实际开始时间',
  `reality_end_time` datetime DEFAULT NULL COMMENT '实际结束时间',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `oa_leave_create_by` (`create_by`),
  KEY `oa_leave_process_instance_id` (`process_instance_id`),
  KEY `oa_leave_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_leave` */

/*Table structure for table `oa_patent` */

CREATE TABLE `oa_patent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author1` varchar(255) DEFAULT NULL,
  `author2` varchar(255) DEFAULT NULL,
  `author3` varchar(255) DEFAULT NULL,
  `other_author` varchar(255) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `title` varchar(1024) DEFAULT NULL,
  `time` varchar(10) DEFAULT NULL,
  `number` varchar(100) DEFAULT NULL,
  `jl` varchar(45) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `category` char(4) DEFAULT NULL,
  `weight` varchar(45) DEFAULT NULL,
  `weight_belong` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_patent` */

/*Table structure for table `oa_project` */

CREATE TABLE `oa_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author1` varchar(255) DEFAULT NULL,
  `author2` varchar(255) DEFAULT NULL,
  `author3` varchar(255) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `project_name` varchar(100) DEFAULT NULL,
  `xb_fee` varchar(45) DEFAULT NULL,
  `sd_fee` varchar(45) DEFAULT NULL,
  `sy_fee` varchar(45) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `project_no` varchar(100) DEFAULT NULL,
  `endtype` varchar(4) DEFAULT NULL,
  `level` varchar(4) DEFAULT NULL,
  `approval_org` varchar(100) DEFAULT NULL,
  `pt_fee` varchar(45) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `weight_belong` int(11) DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  `weight` varchar(45) DEFAULT NULL,
  `process_status` varchar(255) DEFAULT NULL,
  `audit_date` varchar(10) DEFAULT NULL,
  `mid_term_file` varchar(255) DEFAULT NULL,
  `end_file` varchar(255) DEFAULT NULL,
  `mid_term_file_templete` varchar(255) DEFAULT NULL,
  `end_file_templete` varchar(255) DEFAULT NULL,
  `notice` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_project` */

/*Table structure for table `oa_project_user` */

CREATE TABLE `oa_project_user` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `finished` tinyint(2) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT NULL,
  `creativity` int(10) DEFAULT NULL,
  `advancement` int(10) DEFAULT NULL,
  `scientificity` int(10) DEFAULT NULL,
  `feasibility` int(10) DEFAULT NULL,
  `practicability` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_project_user` */

/*Table structure for table `oa_reward` */

CREATE TABLE `oa_reward` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author1` varchar(255) DEFAULT NULL,
  `author2` varchar(255) DEFAULT NULL,
  `author3` varchar(255) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `reward_name` varchar(100) DEFAULT NULL,
  `xb_fee` varchar(45) DEFAULT NULL,
  `jl_first` varchar(45) DEFAULT NULL,
  `jl_second` varchar(45) DEFAULT NULL,
  `case_count_first` varchar(45) DEFAULT NULL,
  `case_count_second` varchar(45) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `year` varchar(15) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `reward_no` varchar(100) DEFAULT NULL,
  `level` varchar(4) DEFAULT NULL,
  `approval_org` varchar(100) DEFAULT NULL,
  `pt_fee` varchar(45) DEFAULT NULL,
  `weight_belong` int(11) DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  `weight` varchar(45) DEFAULT NULL,
  `process_status` varchar(255) DEFAULT NULL,
  `reward_type` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `grade` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_reward` */

/*Table structure for table `oa_reward_user` */

CREATE TABLE `oa_reward_user` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `reward_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `finished` tinyint(2) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT NULL,
  `one` int(10) DEFAULT NULL,
  `two` int(10) DEFAULT NULL,
  `three` int(10) DEFAULT NULL,
  `four` int(10) DEFAULT NULL,
  `five` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_reward_user` */

/*Table structure for table `oa_thesis` */

CREATE TABLE `oa_thesis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author1` varchar(255) DEFAULT NULL,
  `author2` varchar(255) DEFAULT NULL,
  `author3` varchar(255) DEFAULT NULL,
  `co_author` varchar(255) DEFAULT NULL,
  `office_id` int(11) DEFAULT NULL,
  `title` varchar(1024) DEFAULT NULL,
  `mag_name` varchar(100) DEFAULT NULL,
  `annual_volume` varchar(100) DEFAULT NULL,
  `level` char(4) DEFAULT NULL,
  `ybm_fee` varchar(45) DEFAULT NULL,
  `bx_fee` varchar(45) DEFAULT NULL,
  `jl` varchar(45) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `create_by` varchar(45) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(45) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` char(1) DEFAULT '0',
  `process_instance_id` varchar(64) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `category` char(4) DEFAULT NULL,
  `weight` varchar(45) DEFAULT NULL,
  `weight_belong` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oa_thesis` */

/*Table structure for table `sys_area` */

CREATE TABLE `sys_area` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `parent_id` bigint(20) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(255) NOT NULL COMMENT '所有父级编号',
  `code` varchar(100) DEFAULT NULL COMMENT '区域编码',
  `name` varchar(100) NOT NULL COMMENT '区域名称',
  `type` char(1) DEFAULT NULL COMMENT '区域类型（1：国家；2：省份、直辖市；3：地市；4：区县）',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `sys_area_parent_id` (`parent_id`),
  KEY `sys_area_parent_ids` (`parent_ids`),
  KEY `sys_area_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='区域表';

/*Data for the table `sys_area` */

insert  into `sys_area`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,0,'0,','100000','中国','1',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_area`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (2,1,'0,1,','110000','XX市','3',1,'2013-05-27 08:00:00',1,'2015-04-01 11:23:57','','0');

/*Table structure for table `sys_dict` */

CREATE TABLE `sys_dict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `label` varchar(100) NOT NULL COMMENT '标签名',
  `value` varchar(100) NOT NULL COMMENT '数据值',
  `type` varchar(100) NOT NULL COMMENT '类型',
  `description` varchar(100) NOT NULL COMMENT '描述',
  `sort` int(11) NOT NULL COMMENT '排序（升序）',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `sys_dict_value` (`value`),
  KEY `sys_dict_label` (`label`),
  KEY `sys_dict_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=194 DEFAULT CHARSET=utf8 COMMENT='字典表';

/*Data for the table `sys_dict` */

insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,'正常','0','del_flag','删除标记',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (2,'删除','1','del_flag','删除标记',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (3,'显示','1','show_hide','显示/隐藏',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (4,'隐藏','0','show_hide','显示/隐藏',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (5,'是','1','yes_no','是/否',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (6,'否','0','yes_no','是/否',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (7,'红色','red','color','颜色值',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (8,'绿色','green','color','颜色值',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (9,'蓝色','blue','color','颜色值',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (10,'黄色','yellow','color','颜色值',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (11,'橙色','orange','color','颜色值',50,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (12,'默认主题','default','theme','主题方案',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (13,'天蓝主题','cerulean','theme','主题方案',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (14,'橙色主题','readable','theme','主题方案',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (15,'红色主题','united','theme','主题方案',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (16,'Flat主题','flat','theme','主题方案',60,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (17,'国家','1','sys_area_type','区域类型',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (18,'省份、直辖市','2','sys_area_type','区域类型',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (19,'地市','3','sys_area_type','区域类型',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (20,'区县','4','sys_area_type','区域类型',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (21,'医院','1','sys_office_type','机构类型',60,1,'2013-05-27 08:00:00',1,'2015-04-01 11:16:35',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (22,'科室','2','sys_office_type','机构类型',70,1,'2013-05-27 08:00:00',1,'2015-04-01 11:16:44',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (23,'一级','1','sys_office_grade','机构等级',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (24,'二级','2','sys_office_grade','机构等级',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (25,'三级','3','sys_office_grade','机构等级',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (26,'四级','4','sys_office_grade','机构等级',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (27,'所有数据','1','sys_data_scope','数据范围',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (28,'所在医院及以下数据','2','sys_data_scope','数据范围',20,1,'2013-05-27 08:00:00',1,'2015-04-01 11:15:12',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (29,'所在医院数据','3','sys_data_scope','数据范围',30,1,'2013-05-27 08:00:00',1,'2015-04-01 11:15:23',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (30,'所在科室及以下数据','4','sys_data_scope','数据范围',40,1,'2013-05-27 08:00:00',1,'2015-04-01 11:15:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (31,'所在科室数据','5','sys_data_scope','数据范围',50,1,'2013-05-27 08:00:00',1,'2015-04-01 11:15:47',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (32,'仅本人数据','8','sys_data_scope','数据范围',90,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (33,'按明细设置','9','sys_data_scope','数据范围',100,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (34,'系统管理','1','sys_user_type','用户类型',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (35,'科室管理','2','sys_user_type','用户类型',20,1,'2013-05-27 08:00:00',1,'2015-04-01 12:13:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (36,'普通用户','3','sys_user_type','用户类型',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (37,'基础主题','basic','cms_theme','站点主题',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (38,'蓝色主题','blue','cms_theme','站点主题',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (39,'红色主题','red','cms_theme','站点主题',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (40,'文章模型','article','cms_module','栏目模型',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (41,'图片模型','picture','cms_module','栏目模型',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (42,'下载模型','download','cms_module','栏目模型',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (43,'链接模型','link','cms_module','栏目模型',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (44,'专题模型','special','cms_module','栏目模型',50,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (45,'默认展现方式','0','cms_show_modes','展现方式',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (46,'首栏目内容列表','1','cms_show_modes','展现方式',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (47,'栏目第一条内容','2','cms_show_modes','展现方式',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (48,'待审核','0','cms_del_flag','内容状态',10,1,'2013-05-27 08:00:00',1,'2015-05-20 13:27:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (49,'已删除','1','cms_del_flag','内容状态',20,1,'2013-05-27 08:00:00',1,'2015-05-20 13:27:23',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (50,'审核通过','2','cms_del_flag','内容状态',5,1,'2013-05-27 08:00:00',1,'2015-05-20 13:27:13',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (51,'首页焦点图','1','cms_posid','推荐位',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (52,'栏目页文章推荐','2','cms_posid','推荐位',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (53,'咨询','1','cms_guestbook','留言板分类',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (54,'建议','2','cms_guestbook','留言板分类',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (55,'投诉','3','cms_guestbook','留言板分类',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (56,'其它','4','cms_guestbook','留言板分类',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (57,'公休','1','oa_leave_type','请假类型',10,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (58,'病假','2','oa_leave_type','请假类型',20,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (59,'事假','3','oa_leave_type','请假类型',30,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (60,'调休','4','oa_leave_type','请假类型',40,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (61,'婚假','5','oa_leave_type','请假类型',60,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (62,'接入日志','1','sys_log_type','日志类型',30,1,'2013-06-03 08:00:00',1,'2013-06-03 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (63,'异常日志','2','sys_log_type','日志类型',40,1,'2013-06-03 08:00:00',1,'2013-06-03 08:00:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (64,'学术经费','4','oa_expense_type','经费类型',40,1,'2015-04-02 17:16:54',1,'2015-04-02 17:32:03',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (65,'成果经费','3','oa_expense_type','经费类型',30,1,'2015-04-02 17:17:16',1,'2015-04-02 17:31:48',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (66,'论文经费','2','oa_expense_type','经费类型',20,1,'2015-04-02 17:17:31',1,'2015-04-02 17:31:31',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (67,'项目经费','1','oa_expense_type','经费类型',10,1,'2015-04-02 17:17:51',1,'2015-06-09 11:10:03',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (68,'住院医师','1','job_title','医院职称',10,1,'2015-05-08 13:23:50',1,'2015-05-08 13:23:50',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (69,'主治医师','2','job_title','医院职称',10,1,'2015-05-08 13:24:20',1,'2015-05-08 13:24:20',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (70,'副主任医师','3','job_title','医院职称',10,1,'2015-05-08 13:24:38',1,'2015-05-08 13:24:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (71,'主任医师','4','job_title','医院职称',10,1,'2015-05-08 13:25:00',1,'2015-05-08 13:25:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (72,'本科','1','education_type','学历类型',10,1,'2015-05-08 14:03:34',1,'2015-05-08 14:03:34',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (73,'硕士','2','education_type','学历类型',10,1,'2015-05-08 14:03:57',1,'2015-05-08 14:03:57',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (74,'博士','3','education_type','学历类型',10,1,'2015-05-08 14:04:15',1,'2015-05-08 14:04:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (75,'大专','4','education_type','学历类型',10,1,'2015-05-08 14:04:32',1,'2015-05-08 14:04:32',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (76,'SCI','1','thesis_level_type','论文类型',10,1,'2015-05-08 14:42:32',1,'2015-05-08 14:42:32',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (77,'中华','2','thesis_level_type','论文类型',10,1,'2015-05-08 14:42:50',1,'2015-05-08 14:42:50',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (78,'核心','3','thesis_level_type','论文类型',10,1,'2015-05-08 14:43:07',1,'2015-05-08 14:43:07',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (79,'统计源','4','thesis_level_type','论文类型',10,1,'2015-05-08 14:43:24',1,'2015-05-08 14:43:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (80,'省级','5','thesis_level_type','论文类型',10,1,'2015-05-08 14:43:47',1,'2015-05-08 14:43:47',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (81,'其他','6','thesis_level_type','论文类型',20,1,'2015-05-08 14:44:01',1,'2015-06-17 14:36:20',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (82,'论著类','1','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:58:10',1,'2015-05-08 14:58:10',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (83,'病例报告类','2','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:58:28',1,'2015-05-08 14:58:28',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (84,'综述类','3','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:58:44',1,'2015-06-17 14:40:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (85,'评论类','4','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:59:02',1,'2015-05-08 14:59:02',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (86,'简报类','5','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:59:19',1,'2015-05-08 14:59:19',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (87,'会议纪要类','6','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:59:33',1,'2015-05-08 14:59:33',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (88,'消息动态类','7','thesis_category_type','论文类别类型',10,1,'2015-05-08 14:59:51',1,'2015-05-08 14:59:51',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (89,'荟萃分析给编辑的信','8','thesis_category_type','论文类别类型',10,1,'2015-05-08 15:01:14',1,'2015-05-08 15:01:14',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (90,'约稿','9','thesis_category_type','论文类别类型',10,1,'2015-05-08 15:01:38',1,'2015-05-08 15:01:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (91,'','0','thesis_category_type','论文类别类型',5,1,'2015-05-16 11:01:53',1,'2015-05-20 13:28:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (92,'','0','thesis_level_type','论文类型',5,1,'2015-05-16 11:02:27',1,'2015-05-20 13:28:14',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (93,'国家','国家','project_level','项目级别',10,1,'2015-06-02 10:27:24',1,'2015-06-02 11:56:10',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (94,'省级','省级','project_level','项目级别',10,1,'2015-06-02 10:28:07',1,'2015-06-02 11:56:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (95,'卫计委','卫计委','project_level','项目级别',10,1,'2015-06-02 10:28:31',1,'2015-06-02 11:56:21',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (96,'市级','市级','project_level','项目级别',10,1,'2015-06-02 10:28:44',1,'2015-06-02 11:56:26',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (97,'其他渠道','其他渠道','project_level','项目级别',10,1,'2015-06-02 10:28:54',1,'2015-06-02 11:56:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (98,'审核中','审核中','project_status','项目状态',10,1,'2015-06-04 10:09:13',1,'2015-06-04 10:09:13',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (99,'立项通过','立项通过','project_status','项目状态',10,1,'2015-06-04 10:09:39',1,'2015-06-04 10:11:04',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (100,'待审核','待审核','project_status','项目状态',10,1,'2015-06-04 10:10:21',1,'2015-06-04 10:10:21',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (101,'','0','award_level_type','奖励级别',10,1,'2015-06-05 17:52:42',1,'2015-06-05 17:52:42',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (102,'市级','1','award_level_type','奖励级别',10,1,'2015-06-05 17:52:58',1,'2015-06-05 17:52:58',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (103,'省级','2','award_level_type','奖励级别',10,1,'2015-06-05 17:53:13',1,'2015-06-05 17:53:13',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (104,'国家级','3','award_level_type','奖励级别',10,1,'2015-06-05 17:53:24',1,'2015-06-05 17:53:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (105,'','0','achievement_jl_level_type','奖励等级',10,1,'2015-06-05 17:54:11',1,'2015-06-05 17:54:11',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (106,'一等奖','1','achievement_jl_level_type','奖励等级',10,1,'2015-06-05 17:54:25',1,'2015-06-05 17:54:25',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (107,'二等奖','2','achievement_jl_level_type','奖励等级',10,1,'2015-06-05 17:54:37',1,'2015-06-05 17:54:37',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (108,'三等奖','3','achievement_jl_level_type','奖励等级',10,1,'2015-06-05 17:54:47',1,'2015-06-05 17:54:47',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (109,'外文','7','thesis_level_type','论文类型',10,1,'2015-06-17 14:35:48',1,'2015-06-17 14:35:48',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (110,'信件','10','thesis_category_type','论文类别类型',10,1,'2015-06-17 14:39:44',1,'2015-06-17 14:39:44',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (111,'男','0','sex','性别',10,1,'2015-07-13 16:59:24',1,'2015-07-13 16:59:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (112,'女','1','sex','性别',11,1,'2015-07-13 16:59:38',1,'2015-07-13 16:59:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (113,'中专','0','degree','学历',10,1,'2015-07-13 17:03:32',1,'2015-07-13 17:03:32',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (114,'大专','1','degree','学历',11,1,'2015-07-13 17:03:50',1,'2015-07-13 17:03:50',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (115,'本科','2','degree','学历',12,1,'2015-07-13 17:04:10',1,'2015-07-13 17:04:10',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (116,'研究生','3','degree','学历',19,1,'2015-07-13 17:04:24',1,'2015-07-13 17:04:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (117,'学士','0','educational_background','学位',10,1,'2015-07-13 17:07:52',1,'2015-07-13 17:07:52',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (118,'硕士','1','educational_background','学位',20,1,'2015-07-13 17:08:08',1,'2015-07-13 17:08:08',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (119,'博士','2','educational_background','学位',30,1,'2015-07-13 17:08:19',1,'2015-07-13 17:08:19',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (120,'护理','0','prefression','专业',10,1,'2015-07-13 17:11:26',1,'2015-07-13 17:11:26',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (121,'药学','1','prefression','专业',20,1,'2015-07-13 17:11:47',1,'2015-07-13 17:11:47',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (122,'中药学','2','prefression','专业',30,1,'2015-07-13 17:11:59',1,'2015-07-13 17:11:59',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (123,'检验','3','prefression','专业',40,1,'2015-07-13 17:12:15',1,'2015-07-13 17:12:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (124,'医师','4','prefression','专业',50,1,'2015-07-13 17:12:31',1,'2015-07-13 17:12:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (125,'卫生管理','5','prefression','专业',60,1,'2015-07-13 17:12:43',1,'2015-07-13 17:12:43',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (126,'政工','6','prefression','专业',70,1,'2015-07-13 17:12:56',1,'2015-07-13 17:12:56',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (127,'护士','0','title_0','职称',10,1,'2015-07-13 17:47:38',1,'2015-07-13 17:47:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (128,'护师','1','title_0','职称',20,1,'2015-07-13 17:47:52',1,'2015-07-13 17:47:52',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (129,'主管护师','2','title_0','职称',30,1,'2015-07-13 17:48:04',1,'2015-07-13 17:48:04',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (130,'副主任护师','3','title_0','职称',40,1,'2015-07-13 17:49:15',1,'2015-07-13 17:49:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (131,'主任护师','4','title_0','职称',50,1,'2015-07-13 17:49:29',1,'2015-07-13 17:49:29',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (132,'初级药士','5','title_1','职称',60,1,'2015-07-13 17:49:51',1,'2015-07-13 17:49:51',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (133,'初级药师','6','title_1','职称',70,1,'2015-07-13 17:50:13',1,'2015-07-13 17:50:13',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (134,'中级主管药师','7','title_1','职称',80,1,'2015-07-13 17:51:07',1,'2015-07-13 17:51:07',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (135,'副主任药剂师','8','title_1','职称',90,1,'2015-07-13 17:51:24',1,'2015-07-13 17:51:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (136,'主任药剂师','9','title_1','职称',100,1,'2015-07-13 17:51:37',1,'2015-07-13 17:51:37',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (137,'初级中药士','10','title_2','职称',110,1,'2015-07-13 17:51:55',1,'2015-07-13 17:51:55',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (138,'初级中药师','11','title_2','职称',120,1,'2015-07-13 17:52:15',1,'2015-07-13 17:53:11',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (139,'中级主管中药师','12','title_2','职称',130,1,'2015-07-13 17:52:25',1,'2015-07-13 17:53:23',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (140,'副主任药剂师','13','title_2','职称',140,1,'2015-07-13 17:52:40',1,'2015-07-13 17:52:40',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (141,'主任药剂师','14','title_2','职称',150,1,'2015-07-13 17:53:47',1,'2015-07-13 17:53:47',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (142,'初级检验技士','15','title_3','职称',160,1,'2015-07-13 17:54:43',1,'2015-07-13 17:54:43',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (143,'初级检验技师','16','title_3','职称',170,1,'2015-07-13 17:55:00',1,'2015-07-13 17:55:00',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (144,'检验主管技师','17','title_3','职称',180,1,'2015-07-13 17:55:14',1,'2015-07-13 17:55:14',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (145,'副主任检验师','18','title_3','职称',190,1,'2015-07-13 17:55:28',1,'2015-07-13 17:55:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (146,'主任检验师','19','title_3','职称',200,1,'2015-07-13 17:55:52',1,'2015-07-13 17:55:52',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (147,'助理医师','20','title_4','职称',210,1,'2015-07-13 17:56:21',1,'2015-07-13 17:56:21',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (148,'医师','21','title_4','职称',220,1,'2015-07-13 17:56:37',1,'2015-07-13 17:56:37',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (149,'主治医师','22','title_4','职称',230,1,'2015-07-13 17:56:51',1,'2015-07-13 17:56:51',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (150,'副主任医师','23','title_4','职称',240,1,'2015-07-13 17:57:06',1,'2015-07-13 17:57:06',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (151,'主任医师','24','title_4','职称',250,1,'2015-07-13 17:57:21',1,'2015-07-13 17:57:21',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (152,'实习研究员','25','title_5','职称',260,1,'2015-07-13 17:57:42',1,'2015-07-13 17:57:42',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (153,'助理研究员','26','title_5','职称',270,1,'2015-07-13 18:00:25',1,'2015-07-13 18:00:25',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (154,'副研究员','27','title_5','职称',280,1,'2015-07-13 18:00:43',1,'2015-07-13 18:00:43',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (155,'研究员','28','title_5','职称',290,1,'2015-07-13 18:00:59',1,'2015-07-13 18:00:59',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (156,'政工员','29','title_6','职称',300,1,'2015-07-13 18:01:18',1,'2015-07-13 18:01:18',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (157,'助理政工师','30','title_6','职称',310,1,'2015-07-13 18:01:39',1,'2015-07-13 18:01:39',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (158,'中级政工师','31','title_6','职称',320,1,'2015-07-13 18:01:53',1,'2015-07-13 18:01:53',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (159,'高级政工师','32','title_6','职称',330,1,'2015-07-13 18:02:10',1,'2015-07-13 18:02:10',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (160,'','0','patent_category_type','专利类型',10,1,'2015-07-27 16:55:17',1,'2015-07-27 16:55:17',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (161,'发明专利','1','patent_category_type','专利类型',20,1,'2015-07-27 16:55:49',1,'2015-07-27 16:55:49',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (162,'实用新型专利','2','patent_category_type','专利类型',40,1,'2015-07-27 16:56:09',1,'2015-07-27 16:56:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (163,'外观设计专利','3','patent_category_type','专利类型',50,1,'2015-07-27 16:56:24',1,'2015-07-27 16:56:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (164,'','0','book_role_type','著作承担角色',10,1,'2015-07-29 11:02:17',1,'2015-07-29 11:02:17',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (165,'主编','1','book_role_type','著作承担角色',20,1,'2015-07-29 11:02:32',1,'2015-07-29 11:03:02',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (166,'副主编','2','book_role_type','著作承担角色',30,1,'2015-07-29 11:02:42',1,'2015-07-29 11:03:07',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (167,'编委','3','book_role_type','著作承担角色',40,1,'2015-07-29 11:02:52',1,'2015-07-29 11:03:12',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (168,'','0','reward_grade','奖励等级',10,1,'2015-08-16 09:43:52',1,'2015-08-16 09:43:52',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (169,'市级','1','reward_grade','奖励等级',20,1,'2015-08-16 09:44:03',1,'2015-08-16 09:44:03',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (170,'省级','2','reward_grade','奖励等级',30,1,'2015-08-16 09:44:17',1,'2015-08-16 09:44:17',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (171,'国家级','3','reward_grade','奖励等级',40,1,'2015-08-16 09:44:30',1,'2015-08-16 09:44:30',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (172,'','0','reward_level','奖励等级',10,1,'2015-08-16 09:44:58',1,'2015-08-16 09:44:58',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (173,'一等奖','1','reward_level','奖励等级',20,1,'2015-08-16 09:45:14',1,'2015-08-16 09:45:14',NULL,'1');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (174,'一等奖','1','reward_level','奖励等级',20,1,'2015-08-16 09:45:15',1,'2015-08-16 09:45:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (175,'二等奖','2','reward_level','奖励等级',30,1,'2015-08-16 09:45:27',1,'2015-08-16 09:45:27',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (176,'国际级','0','academic_level_type','会议级别',10,1,'2015-08-19 17:05:03',1,'2015-08-19 17:05:03',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (177,'国家级','1','academic_level_type','会议级别',20,1,'2015-08-19 17:05:31',1,'2015-08-19 17:05:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (178,'港澳台','2','academic_level_type','会议级别',30,1,'2015-08-19 17:06:24',1,'2015-08-19 17:06:24',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (179,'省级','3','academic_level_type','会议级别',40,1,'2015-08-19 17:07:03',1,'2015-08-19 17:07:03',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (180,'市级','4','academic_level_type','会议级别',50,1,'2015-08-19 17:07:31',1,'2015-08-19 17:07:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (181,'参会','1','academic_exercise_role','参会形式',10,1,'2015-08-19 17:08:47',1,'2015-08-19 17:08:47',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (182,'大会发言','2','academic_exercise_role','参会形式',20,1,'2015-08-19 17:09:00',1,'2015-08-19 17:10:31',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (183,'壁报','3','academic_exercise_role','参会形式',20,1,'2015-08-19 17:09:44',1,'2015-08-19 17:10:27',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (184,'材料参编','4','academic_exercise_role','参会形式',30,1,'2015-08-19 17:10:15',1,'2015-08-19 17:10:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (185,'市级','1','acad_level_type','级别',10,1,'2015-08-19 17:12:20',1,'2015-08-19 17:12:20',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (186,'省级','2','acad_level_type','级别',20,1,'2015-08-19 17:12:38',1,'2015-08-19 17:12:38',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (187,'国家级','3','acad_level_type','级别',20,1,'2015-08-19 17:12:55',1,'2015-08-19 17:12:55',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (188,'主委','1','acad_exercise_role','职务',10,1,'2015-08-19 17:13:27',1,'2015-08-19 17:13:27',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (189,'副主委','2','acad_exercise_role','职务',20,1,'2015-08-19 17:13:37',1,'2015-08-19 17:16:07',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (190,'常委','3','acad_exercise_role','职务',20,1,'2015-08-19 17:14:56',1,'2015-08-19 17:16:04',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (191,'委员','4','acad_exercise_role','职务',30,1,'2015-08-19 17:15:19',1,'2015-08-19 17:16:12',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (192,'秘书长','5','acad_exercise_role','职务',40,1,'2015-08-19 17:15:37',1,'2015-08-19 17:16:15',NULL,'0');
insert  into `sys_dict`(`id`,`label`,`value`,`type`,`description`,`sort`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (193,'秘书','6','acad_exercise_role','职务',50,1,'2015-08-19 17:15:56',1,'2015-08-19 17:16:19',NULL,'0');

/*Table structure for table `sys_log` */

CREATE TABLE `sys_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` char(1) DEFAULT '1' COMMENT '日志类型（1：接入日志；2：异常日志）',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `remote_addr` varchar(255) DEFAULT NULL COMMENT '操作IP地址',
  `user_agent` varchar(255) DEFAULT NULL COMMENT '用户代理',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '请求URI',
  `method` varchar(5) DEFAULT NULL COMMENT '操作方式',
  `params` text COMMENT '操作提交的数据',
  `exception` text COMMENT '异常信息',
  PRIMARY KEY (`id`),
  KEY `sys_log_create_by` (`create_by`),
  KEY `sys_log_request_uri` (`request_uri`),
  KEY `sys_log_type` (`type`),
  KEY `sys_log_create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sys_log` */

/*Table structure for table `sys_mdict` */

CREATE TABLE `sys_mdict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `parent_id` bigint(20) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(255) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '角色名称',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `sort` int(11) DEFAULT NULL COMMENT '排序（升序）',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `sys_mdict_parent_id` (`parent_id`),
  KEY `sys_mdict_parent_ids` (`parent_ids`),
  KEY `sys_mdict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='区域表';

/*Data for the table `sys_mdict` */

/*Table structure for table `sys_menu` */

CREATE TABLE `sys_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `parent_id` bigint(20) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(255) NOT NULL COMMENT '所有父级编号',
  `name` varchar(100) NOT NULL COMMENT '菜单名称',
  `href` varchar(255) DEFAULT NULL COMMENT '链接',
  `target` varchar(20) DEFAULT NULL COMMENT '目标（mainFrame、 _blank、_self、_parent、_top）',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `sort` int(11) NOT NULL COMMENT '排序（升序）',
  `is_show` char(1) NOT NULL COMMENT '是否在菜单中显示（1：显示；0：不显示）',
  `permission` varchar(200) DEFAULT NULL COMMENT '权限标识',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `sys_menu_parent_id` (`parent_id`),
  KEY `sys_menu_parent_ids` (`parent_ids`),
  KEY `sys_menu_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8 COMMENT='菜单表';

/*Data for the table `sys_menu` */

insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,0,'0,','顶级菜单',NULL,NULL,NULL,0,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (2,1,'0,1,','系统设置',NULL,NULL,NULL,300,'1',NULL,1,'2013-05-27 08:00:00',1,'2015-05-29 11:26:33',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (3,2,'0,1,2,','系统设置',NULL,NULL,NULL,980,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (4,3,'0,1,2,3,','菜单管理','/sys/menu/',NULL,'list-alt',30,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (5,4,'0,1,2,3,4,','查看',NULL,NULL,NULL,30,'0','sys:menu:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (6,4,'0,1,2,3,4,','修改',NULL,NULL,NULL,30,'0','sys:menu:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (7,3,'0,1,2,3,','角色管理','/sys/role/',NULL,'lock',50,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (8,7,'0,1,2,3,7,','查看',NULL,NULL,NULL,30,'0','sys:role:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (9,7,'0,1,2,3,7,','修改',NULL,NULL,NULL,30,'0','sys:role:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (10,3,'0,1,2,3,','字典管理','/sys/dict/',NULL,'th-list',60,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (11,10,'0,1,2,3,10,','查看',NULL,NULL,NULL,30,'0','sys:dict:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (12,10,'0,1,2,3,10,','修改',NULL,NULL,NULL,30,'0','sys:dict:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (13,2,'0,1,2,','机构用户',NULL,NULL,NULL,970,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (14,13,'0,1,2,13,','区域管理','/sys/area/',NULL,'th',50,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (15,14,'0,1,2,13,14,','查看',NULL,NULL,NULL,30,'0','sys:area:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (16,14,'0,1,2,13,14,','修改',NULL,NULL,NULL,30,'0','sys:area:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (17,13,'0,1,2,13,','机构管理','/sys/office/',NULL,'th-large',40,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (18,17,'0,1,2,13,17,','查看',NULL,NULL,NULL,30,'0','sys:office:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (19,17,'0,1,2,13,17,','修改',NULL,NULL,NULL,30,'0','sys:office:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (20,13,'0,1,2,13,','用户管理','/sys/user/',NULL,'user',30,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (21,20,'0,1,2,13,20,','查看',NULL,NULL,NULL,30,'0','sys:user:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (22,20,'0,1,2,13,20,','修改',NULL,NULL,NULL,30,'0','sys:user:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (23,2,'0,1,2,','关于帮助',NULL,NULL,NULL,990,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (24,23,'0,1,2,23,','项目首页','https://www.baidu.com/','_blank','',30,'1','',1,'2013-05-27 08:00:00',1,'2015-04-01 11:42:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (27,1,'0,1,','我的面板',NULL,NULL,NULL,400,'1',NULL,1,'2013-05-27 08:00:00',1,'2015-05-29 11:26:32',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (28,27,'0,1,27,','个人信息',NULL,NULL,NULL,990,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (29,28,'0,1,27,28,','个人信息','/sys/user/info',NULL,'user',30,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (30,28,'0,1,27,28,','修改密码','/sys/user/modifyPwd',NULL,'lock',40,'1',NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (31,1,'0,1,','统计管理','','','',200,'1','',1,'2013-05-27 08:00:00',1,'2015-08-19 16:50:06',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (32,31,'0,1,31,','栏目设置','','','',990,'0','',1,'2013-05-27 08:00:00',1,'2015-08-20 10:55:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (33,32,'0,1,31,32,','栏目管理','/cms/category/',NULL,'align-justify',30,'1',NULL,1,'2013-05-27 08:00:00',1,'2015-05-29 11:26:33',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (34,33,'0,1,31,32,33,','查看',NULL,NULL,NULL,30,'0','cms:category:view',1,'2013-05-27 08:00:00',1,'2015-05-29 11:26:33',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (35,33,'0,1,31,32,33,','修改',NULL,NULL,NULL,30,'0','cms:category:edit',1,'2013-05-27 08:00:00',1,'2015-05-29 11:26:33',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (36,32,'0,1,31,32,','站点设置','/cms/site/',NULL,'certificate',40,'1',NULL,1,'2013-05-27 08:00:00',1,'2015-08-19 17:49:56',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (37,36,'0,1,31,32,,36,','查看',NULL,NULL,NULL,30,'0','cms:site:view',1,'2013-05-27 08:00:00',1,'2015-08-19 17:49:56',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (38,36,'0,1,31,32,,36,','修改',NULL,NULL,NULL,30,'0','cms:site:edit',1,'2013-05-27 08:00:00',1,'2015-08-19 17:49:56',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (39,32,'0,1,31,32','切换站点','/cms/site/select',NULL,'retweet',50,'1','cms:site:select',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (40,31,'0,1,31,','统计管理','','','',500,'1','cms:view',1,'2013-05-27 08:00:00',1,'2015-08-19 16:49:20',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (41,106,'0,1,62,106,','统计','/cms/thesis/','','briefcase',40,'1','cms:thesis:view',1,'2013-05-27 08:00:00',1,'2015-08-20 10:44:30',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (42,41,'0,1,62,106,41,','文章模型','/cms/article/',NULL,'file',40,'0',NULL,1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (43,42,'0,1,62,106,41,42,','查看',NULL,NULL,NULL,30,'0','cms:article:view',1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (44,42,'0,1,62,106,41,42,','修改',NULL,NULL,NULL,30,'0','cms:article:edit',1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (45,42,'0,1,62,106,41,42,','审核',NULL,NULL,NULL,30,'0','cms:article:audit',1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (46,41,'0,1,62,106,41,','链接模型','/cms/link/',NULL,'random',60,'0',NULL,1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (47,46,'0,1,62,106,41,46,','查看',NULL,NULL,NULL,30,'0','cms:link:view',1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (48,46,'0,1,62,106,41,46,','修改',NULL,NULL,NULL,30,'0','cms:link:edit',1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (49,46,'0,1,62,106,41,46,','审核',NULL,NULL,NULL,30,'0','cms:link:audit',1,'2013-05-27 08:00:00',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (50,40,'0,1,31,40,','评论管理','/cms/comment/?status=2','','comment',4000,'0','',1,'2013-05-27 08:00:00',1,'2015-08-20 10:58:58',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (51,50,'0,1,31,40,50,','查看',NULL,NULL,NULL,30,'0','cms:comment:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (52,50,'0,1,31,40,50,','审核',NULL,NULL,NULL,30,'0','cms:comment:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (53,40,'0,1,31,40,','公共留言','/cms/guestbook/?status=2','','glass',80,'0','',1,'2013-05-27 08:00:00',1,'2015-04-22 15:14:33',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (54,53,'0,1,31,40,53,','查看',NULL,NULL,NULL,30,'0','cms:guestbook:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (55,53,'0,1,31,40,53,','审核',NULL,NULL,NULL,30,'0','cms:guestbook:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (56,40,'0,1,31,40,','文件管理','/../static/ckfinder/ckfinder.html','','folder-open',40,'1','',1,'2013-05-27 08:00:00',1,'2015-08-20 10:58:58',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (57,56,'0,1,31,40,56,','查看',NULL,NULL,NULL,30,'0','cms:ckfinder:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (58,56,'0,1,31,40,56,','上传',NULL,NULL,NULL,30,'0','cms:ckfinder:upload',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (59,56,'0,1,31,40,56,','修改',NULL,NULL,NULL,30,'0','cms:ckfinder:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (60,31,'0,1,31,','统计分析','','','',600,'0','',1,'2013-05-27 08:00:00',1,'2015-05-16 12:06:59',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (61,60,'0,1,31,60,','信息量统计','/cms/stats/article',NULL,'tasks',30,'1','cms:stats:article',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (62,1,'0,1,','个人办公','','','',100,'1','',1,'2013-05-27 08:00:00',1,'2015-08-20 10:38:01',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (63,62,'0,1,62,','个人办公','','','',3000,'0','',1,'2013-05-27 08:00:00',1,'2015-08-20 10:58:54',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (64,63,'0,1,62,63,','请假办理','/oa/leave','','leaf',3000,'0','',1,'2013-05-27 08:00:00',1,'2015-08-20 10:58:56',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (65,64,'0,1,62,63,64,','查看',NULL,NULL,NULL,30,'0','oa:leave:view',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (66,64,'0,1,62,63,64,','修改',NULL,NULL,NULL,30,'0','oa:leave:edit',1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (67,2,'0,1,2,','日志查询','','','',985,'0','',1,'2013-06-03 08:00:00',1,'2015-08-20 10:55:17',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (68,67,'0,1,2,67,','日志查询','/sys/log',NULL,'pencil',30,'1','sys:log:view',1,'2013-06-03 08:00:00',1,'2013-06-03 08:00:00',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (69,62,'0,1,62,','流程管理','','','',300,'0','',1,'2013-05-27 08:00:00',1,'2015-08-18 15:49:11',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (70,69,'0,1,62,69,','流程管理','/oa/workflow/processList','','road',300,'0','oa:workflow:edit',1,'2013-05-27 08:00:00',1,'2015-08-18 15:48:54',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (71,107,'0,1,62,107,','科研项目管理','/oa/expense','','',20,'1','',1,'2015-04-02 16:45:34',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (72,71,'0,1,62,107,71,','查看','','','',30,'0','oa:expense:view',1,'2015-04-02 16:46:02',1,'2015-08-20 10:40:52',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (73,71,'0,1,62,107,71,','修改','','','',30,'0','oa:expense:edit',1,'2015-04-02 16:47:13',1,'2015-08-20 10:40:52',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (74,106,'0,1,62,106,','申报','/oa/thesis','','',30,'1','',1,'2015-04-21 15:30:06',1,'2015-08-20 10:46:16',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (75,74,'0,1,62,106,74,','查看','','','',30,'0','oa:thesis:view',1,'2015-04-21 16:27:43',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (76,74,'0,1,62,106,74,','修改','','','',30,'0','oa:thesis:edit',1,'2015-04-21 16:29:40',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (77,107,'0,1,62,107,','科研项目申报','/oa/project','','',10,'1','',1,'2015-06-01 11:33:26',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (78,77,'0,1,62,107,77,','查看','','','',30,'0','oa:project:view',1,'2015-06-01 11:33:47',1,'2015-08-20 10:38:43',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (79,77,'0,1,62,107,77,','编辑','','','',30,'0','oa:project:edit',1,'2015-06-01 11:35:30',1,'2015-08-20 10:38:43',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (80,107,'0,1,62,107,','科研项目统计','/cms/project/','','',40,'1','cms:project:view',1,'2015-06-01 11:36:06',1,'2015-08-20 10:41:15',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (81,107,'0,1,62,107,','项目经费统计','/cms/expense/','','',50,'1','cms:expense:view',1,'2015-06-05 11:32:23',1,'2015-08-20 10:41:34',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (82,108,'0,1,62,108,','申报','/oa/newTecReward/','','',10,'1','',1,'2015-06-05 17:50:16',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (83,82,'0,1,62,108,82,','查看','','','',30,'0','oa:achievement:view',1,'2015-06-05 17:50:37',1,'2015-08-20 10:42:35',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (84,82,'0,1,62,108,82,','修改','','','',30,'0','oa:achievement:edit',1,'2015-06-05 17:50:53',1,'2015-08-20 10:42:35',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (85,108,'0,1,62,108,','统计','/cms/newTecReward/','','',20,'1','',1,'2015-06-05 17:51:26',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (86,111,'0,1,62,111,','申报','/oa/patent','','',10,'1','',1,'2015-07-27 16:31:37',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (87,111,'0,1,62,111,','统计','/cms/patent','','',32,'1','',1,'2015-07-27 17:47:30',1,'2015-08-20 10:50:58',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (88,112,'0,1,62,112,','申报','/oa/book/','','',15,'1','',1,'2015-07-29 10:52:38',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (89,112,'0,1,62,112,','统计','/cms/book','','',35,'1','',1,'2015-07-29 11:00:04',1,'2015-08-20 10:51:39',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (90,109,'0,1,62,109,','申报','/oa/reward/','','',10,'1','',1,'2015-07-31 17:06:43',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (91,109,'0,1,62,109,','统计','/cms/reward','','',20,'1','',1,'2015-07-31 17:07:09',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (92,114,'0,1,62,114,','申请','/oa/advstudy/','','',10,'1','',1,'2015-08-04 11:20:29',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (93,110,'0,1,62,110,','统计','/cms/tecAdvReward/','','',20,'1','',1,'2015-08-04 11:20:54',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (94,63,'0,1,62,63,','外出申请','/oa/academic','','',30,'1','',1,'2015-08-04 20:12:15',1,'2015-08-04 20:12:15',NULL,'1');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (95,40,'0,1,31,40,','绩效管理','/cms/performance/','','',10,'1','',1,'2015-08-17 14:18:42',1,'2015-08-20 10:58:58',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (96,40,'0,1,31,40,','成果管理','/cms/achieve/','','',20,'1','',1,'2015-08-18 13:57:03',1,'2015-08-20 10:58:58',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (97,40,'0,1,31,40,','通知信息','/cms/notice','','',30,'1','',1,'2015-08-18 15:00:30',1,'2015-08-20 10:58:58',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (98,99,'0,1,62,99,','我的首页','/oa/dashboard','','',1,'1','',1,'2015-08-18 15:53:47',1,'2015-08-18 15:55:29',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (99,62,'0,1,62,','我的首页','/oa/dashboard','','',1,'1','',1,'2015-08-18 15:54:47',1,'2015-08-18 15:54:47',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (100,113,'0,1,62,113,','申请','/oa/academic/','','',10,'1','',1,'2015-08-19 16:37:35',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (101,115,'0,1,62,115,','登记','/oa/acad','','',10,'1','',1,'2015-08-19 16:40:17',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (102,113,'0,1,62,113,','统计','/cms/academic/','','',89,'1','',1,'2015-08-19 16:46:27',1,'2015-08-20 10:52:35',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (103,114,'0,1,62,114,','统计','/cms/advstudy/','','',90,'1','',1,'2015-08-19 16:47:33',1,'2015-08-20 10:53:26',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (104,115,'0,1,62,115,','统计','/cms/acad','','',100,'1','',1,'2015-08-19 17:01:09',1,'2015-08-20 10:54:25',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (105,110,'0,1,62,110,','申报','/oa/tecAdvReward','','',10,'1','',1,'2015-08-19 17:48:57',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (106,62,'0,1,62,','论文','','','',30,'1','',1,'2015-08-20 10:35:03',1,'2015-08-20 10:36:02',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (107,62,'0,1,62,','科研项目','','','',10,'1','',1,'2015-08-20 10:38:27',1,'2015-11-01 16:45:16',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (109,62,'0,1,62,','科技进步奖','','','',20,'1','',1,'2015-08-20 10:47:59',1,'2015-11-01 16:45:30',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (111,62,'0,1,62,','专利','','','',80,'1','',1,'2015-08-20 10:50:30',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (112,62,'0,1,62,','著作','','','',90,'1','',1,'2015-08-20 10:51:15',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (113,62,'0,1,62,','学术活动','','','',100,'1','',1,'2015-08-20 10:51:58',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (114,62,'0,1,62,','外出进修','','','',110,'1','',1,'2015-08-20 10:52:50',1,'2015-08-20 10:58:57',NULL,'0');
insert  into `sys_menu`(`id`,`parent_id`,`parent_ids`,`name`,`href`,`target`,`icon`,`sort`,`is_show`,`permission`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (115,62,'0,1,62,','学会任职登记','','','',120,'1','',1,'2015-08-20 10:53:52',1,'2015-08-20 10:58:57',NULL,'0');

/*Table structure for table `sys_office` */

CREATE TABLE `sys_office` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `parent_id` bigint(20) NOT NULL COMMENT '父级编号',
  `parent_ids` varchar(255) NOT NULL COMMENT '所有父级编号',
  `code` varchar(100) DEFAULT NULL COMMENT '区域编码',
  `name` varchar(100) NOT NULL COMMENT '机构名称',
  `type` char(1) NOT NULL COMMENT '机构类型（1：公司；2：部门；3：小组）',
  `grade` char(1) NOT NULL COMMENT '机构等级（1：一级；2：二级；3：三级；4：四级）',
  `address` varchar(255) DEFAULT NULL COMMENT '联系地址',
  `zip_code` varchar(100) DEFAULT NULL COMMENT '邮政编码',
  `master` varchar(100) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(200) DEFAULT NULL COMMENT '电话',
  `fax` varchar(200) DEFAULT NULL COMMENT '传真',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `sys_office_parent_id` (`parent_id`),
  KEY `sys_office_parent_ids` (`parent_ids`),
  KEY `sys_office_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=456 DEFAULT CHARSET=utf8 COMMENT='部门表';

/*Data for the table `sys_office` */

insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,0,'0,','100000','市第一医院','1','1',NULL,NULL,NULL,NULL,NULL,NULL,1,'2013-05-27 08:00:00',1,'2013-05-27 08:00:00',NULL,'0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (311,1,'0,1,','100001','院级领导','1','1','','','','','','',1,'2015-07-03 11:29:58',1,'2015-07-03 11:29:58','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (312,1,'0,1,','100002','职能科室','1','1','','','','','','',1,'2015-07-03 11:30:12',1,'2015-07-03 11:30:12','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (314,1,'0,1,','100003','医技科室','1','1','','','','','','',1,'2015-07-03 11:32:02',1,'2015-07-03 11:32:02','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (315,1,'0,1,','100004','临床科室','1','1','','','','','','',1,'2015-07-03 11:32:40',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (316,1,'0,1,','100005','护理','1','1','','','','','','',1,'2015-07-03 11:32:57',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (317,312,'0,1,312,','100006','党办','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (318,312,'0,1,312,','100007','工会','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (319,312,'0,1,312,','100008','科教处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (320,312,'0,1,312,','100009','医保处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (321,312,'0,1,312,','100010','培训处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (322,312,'0,1,312,','100011','医患沟通中心','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (323,312,'0,1,312,','100012','质控办','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (324,312,'0,1,312,','100013','财务处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (325,312,'0,1,312,','100014','人事处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (326,312,'0,1,312,','100015','病案管理科','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (327,312,'0,1,312,','100016','司法鉴定所','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (328,312,'0,1,312,','100017','设备处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (329,312,'0,1,312,','100018','药学部','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (330,312,'0,1,312,','100019','经核处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (331,312,'0,1,312,','100020','院办','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (332,312,'0,1,312,','100021','行风建设处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (333,312,'0,1,312,','100022','信息中心','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (334,312,'0,1,312,','100023','宣传处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (335,312,'0,1,312,','100024','医务处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (336,312,'0,1,312,','100025','团委','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (337,312,'0,1,312,','100026','护理部','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (338,312,'0,1,312,','100027','总务处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (339,312,'0,1,312,','100028','感管处','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (340,312,'0,1,312,','100029','门诊部','1','2','','','','','','',1,'2015-07-03 11:33:15',1,'2015-07-03 11:33:15','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (341,314,'0,1,314,','100030','影像（CT室）','1','2','','','','','','',1,'2015-07-03 11:56:07',1,'2015-07-03 11:56:07','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (342,314,'0,1,314,','100031','电生理室','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (343,314,'0,1,314,','100032','核医学放免中心','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (344,314,'0,1,314,','100033','影像（放射科）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (345,314,'0,1,314,','100034','检验（检验科）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (346,314,'0,1,314,','100035','检验（输血科）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (347,314,'0,1,314,','100036','影像（介入放射科）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (348,314,'0,1,314,','100037','影像（超声室）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (349,314,'0,1,314,','100038','病理科','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (350,314,'0,1,314,','100039','影像（MR室）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (351,314,'0,1,314,','100040','检验（中心实验室）','1','1','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (357,315,'0,1,315,','100046','麻醉科','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (358,315,'0,1,315,','100047','营养膳食科','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (373,315,'0,1,315,','100062','生殖中心','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (383,315,'0,1,315,','100072','急诊科','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (390,315,'0,1,315,','100079','耳鼻喉科五病区','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (409,316,'0,1,316,','100098','麻醉科','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (410,316,'0,1,316,','100099','营养膳食科','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (419,316,'0,1,316,','100108','耳鼻喉科四病区','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (425,316,'0,1,316,','100114','生殖中心','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (435,316,'0,1,316,','100124','急诊科','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');
insert  into `sys_office`(`id`,`parent_id`,`parent_ids`,`code`,`name`,`type`,`grade`,`address`,`zip_code`,`master`,`phone`,`fax`,`email`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (442,316,'0,1,316,','100131','耳鼻喉科五病区','1','2','','','','','','',1,'2015-06-16 15:49:00',1,'2015-06-16 15:49:49','','0');

/*Table structure for table `sys_role` */

CREATE TABLE `sys_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `office_id` bigint(20) DEFAULT NULL COMMENT '归属机构',
  `name` varchar(100) NOT NULL COMMENT '角色名称',
  `enname` varchar(255) DEFAULT NULL COMMENT '英文名称',
  `role_type` varchar(255) DEFAULT NULL COMMENT '角色类型',
  `data_scope` char(1) DEFAULT NULL COMMENT '数据范围（0：所有数据；1：所在公司及以下数据；2：所在公司数据；3：所在部门及以下数据；4：所在部门数据；8：仅本人数据；9：按明细设置）',
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  PRIMARY KEY (`id`),
  KEY `sys_role_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Data for the table `sys_role` */

insert  into `sys_role`(`id`,`office_id`,`name`,`enname`,`role_type`,`data_scope`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (1,1,'系统管理员','sys_admin','security-role','1',1,'2013-05-27 08:00:00',1,'2015-05-09 17:23:13',NULL,'0');
insert  into `sys_role`(`id`,`office_id`,`name`,`enname`,`role_type`,`data_scope`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (8,1,'普通人员','user','user','8',1,'2015-05-09 17:20:56',1,'2015-06-17 23:58:59',NULL,'0');
insert  into `sys_role`(`id`,`office_id`,`name`,`enname`,`role_type`,`data_scope`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (9,1,'科教处人员','kjDept','assignment','2',1,'2015-05-09 17:21:43',3,'2015-05-10 09:22:00',NULL,'0');
insert  into `sys_role`(`id`,`office_id`,`name`,`enname`,`role_type`,`data_scope`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (10,1,'医院领导','hosLeader','assignment','2',1,'2015-06-05 14:34:27',1,'2015-06-05 14:34:27',NULL,'0');
insert  into `sys_role`(`id`,`office_id`,`name`,`enname`,`role_type`,`data_scope`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (11,1,'财务处人员','financeDept','assignment','8',1,'2015-06-05 14:36:01',1,'2015-08-28 09:38:07',NULL,'0');
insert  into `sys_role`(`id`,`office_id`,`name`,`enname`,`role_type`,`data_scope`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`) values (12,1,'科室主任','departmentLeader','assignment','4',1,'2015-06-26 18:01:48',1,'2015-06-26 18:01:48',NULL,'0');

/*Table structure for table `sys_role_menu` */

CREATE TABLE `sys_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色编号',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单编号',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-菜单';

/*Data for the table `sys_role_menu` */

insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,23);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,24);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,32);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,33);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,34);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,35);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,36);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,60);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,61);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,67);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,68);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,77);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,78);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,79);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,80);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,81);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,82);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,83);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,84);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,85);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,86);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,87);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,88);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,89);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,90);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,91);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,92);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,93);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,95);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,96);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,97);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,98);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,99);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,100);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,101);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,102);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,103);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,104);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,105);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,106);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,107);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,108);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,109);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,110);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,111);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,112);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,113);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,114);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (1,115);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,23);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,24);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,32);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,33);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,34);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,35);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,53);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,54);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,55);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,60);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,61);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,67);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,68);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (2,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,14);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,15);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,16);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,23);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,24);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,25);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,26);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,32);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,33);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,34);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,35);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,36);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,37);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,38);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,39);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,53);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,54);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,55);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,60);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,61);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,67);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,68);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (3,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,14);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,15);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,16);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,23);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,24);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,25);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,26);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,32);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,33);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,34);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,35);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,36);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,37);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,38);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,39);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,53);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,54);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,55);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,60);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,61);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,67);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,68);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (4,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,23);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,24);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,32);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,33);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,34);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,35);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,53);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,54);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,55);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,60);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,61);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,67);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,68);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (5,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (6,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,4);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,5);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,6);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,14);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,15);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,16);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,23);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,24);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,25);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,26);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,32);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,33);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,34);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,35);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,36);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,37);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,38);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,39);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,53);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,54);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,55);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,60);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,61);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,67);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,68);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,69);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (7,70);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,77);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,78);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,79);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,80);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,81);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,82);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,83);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,84);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,85);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,86);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,87);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,88);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,89);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,90);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,91);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,92);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,93);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,95);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,96);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,98);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,99);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,100);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,101);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,102);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,103);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,104);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,105);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,106);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,107);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,108);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,109);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,110);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,111);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,112);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,113);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,114);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (8,115);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,2);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,3);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,7);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,8);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,9);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,10);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,11);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,12);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,13);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,17);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,18);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,19);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,20);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,21);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,22);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,77);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,78);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,79);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,80);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,81);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,82);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,83);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,84);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,85);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,86);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,87);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,88);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,89);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,90);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,91);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,92);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,93);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,95);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,96);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,97);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,98);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,99);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,100);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,101);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,102);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,103);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,104);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,105);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,106);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,107);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,108);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,109);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,110);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,111);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,112);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,113);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,114);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (9,115);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,63);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,64);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,65);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,66);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,77);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,78);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,79);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,80);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,81);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,82);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,83);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,84);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,85);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,86);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,87);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,88);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,89);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,90);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,91);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,92);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,93);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,95);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,96);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,98);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,99);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,100);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,101);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,102);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,103);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,104);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,105);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,106);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,107);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,108);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,109);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,110);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,111);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,112);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,113);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,114);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (10,115);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,77);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,78);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,79);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,80);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,81);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,82);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,83);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,84);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,85);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,86);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,87);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,88);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,89);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,90);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,91);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,92);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,93);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,95);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,96);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,98);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,99);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,100);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,101);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,102);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,103);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,104);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,105);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,106);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,107);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,108);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,109);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,110);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,111);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,112);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,113);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,114);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (11,115);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,1);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,27);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,28);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,29);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,30);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,31);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,40);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,41);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,42);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,43);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,44);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,45);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,46);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,47);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,48);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,49);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,50);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,51);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,52);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,56);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,57);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,58);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,59);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,62);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,71);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,72);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,73);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,74);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,75);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,76);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,77);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,78);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,79);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,80);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,81);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,82);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,83);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,84);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,85);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,86);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,87);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,88);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,89);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,90);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,91);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,92);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,93);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,95);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,96);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,98);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,99);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,100);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,101);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,102);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,103);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,104);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,105);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,106);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,107);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,108);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,109);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,110);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,111);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,112);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,113);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,114);
insert  into `sys_role_menu`(`role_id`,`menu_id`) values (12,115);

/*Table structure for table `sys_role_office` */

CREATE TABLE `sys_role_office` (
  `role_id` bigint(20) NOT NULL COMMENT '角色编号',
  `office_id` bigint(20) NOT NULL COMMENT '机构编号',
  PRIMARY KEY (`role_id`,`office_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-机构';

/*Data for the table `sys_role_office` */

/*Table structure for table `sys_user` */

CREATE TABLE `sys_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `company_id` bigint(20) NOT NULL COMMENT '归属公司',
  `office_id` bigint(20) NOT NULL COMMENT '归属部门',
  `login_name` varchar(100) NOT NULL COMMENT '登录名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `no` varchar(100) DEFAULT NULL COMMENT '工号',
  `name` varchar(100) NOT NULL COMMENT '姓名',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(200) DEFAULT NULL COMMENT '电话',
  `mobile` varchar(200) DEFAULT NULL COMMENT '手机',
  `user_type` char(1) DEFAULT NULL COMMENT '用户类型',
  `login_ip` varchar(100) DEFAULT NULL COMMENT '最后登陆IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登陆时间',
  `job_title` char(1) DEFAULT NULL,
  `education` char(1) DEFAULT NULL,
  `create_by` bigint(20) DEFAULT NULL COMMENT '创建者',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(20) DEFAULT NULL COMMENT '更新者',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记（0：正常；1：删除）',
  `init_info` tinyint(1) DEFAULT '1' COMMENT '是否改过初始信息',
  `init_psw` tinyint(1) DEFAULT '1' COMMENT '是否改过密码',
  `birthday` varchar(20) DEFAULT NULL,
  `degree` varchar(10) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `prefression` varchar(10) DEFAULT NULL,
  `title` varchar(10) DEFAULT NULL,
  `educational_background` varchar(10) DEFAULT NULL,
  `graduate_advisor` varchar(200) DEFAULT NULL,
  `professional_title` varchar(200) DEFAULT NULL,
  `is_professional` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_user_office_id` (`office_id`),
  KEY `sys_user_login_name` (`login_name`),
  KEY `sys_user_company_id` (`company_id`),
  KEY `sys_user_update_date` (`update_date`),
  KEY `sys_user_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=11623 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Data for the table `sys_user` */

insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (1,1,1,'admin','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','x','admin','','','','1','0:0:0:0:0:0:0:1','2019-03-27 22:08:07','1','1',1,'2013-05-27 08:00:00',1,'2015-08-22 03:45:43','','0',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10000,1,1,'1609','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','1609','普十','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10001,1,1,'1702','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','1702','普九','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10002,1,1,'1703','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','1703','普八','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10003,1,1,'2186','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','2186','普七','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10004,1,1,'0100','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0100','普六','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10005,1,1,'0329','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0329','普五','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10006,1,1,'0375','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0375','普四','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10007,1,1,'1140','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','1140','普三','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:47',1,'2015-07-03 13:45:47','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10008,1,1,'1206','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','1206','普二','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:48',1,'2015-07-03 13:45:48','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10009,1,1,'0522','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0522','普一','','','','',NULL,NULL,'','',1,'2015-07-03 13:45:48',1,'2015-07-03 13:45:48','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10223,1,1,'0480','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0480','科教二','','','','',NULL,NULL,'1','1',1,'2015-07-03 13:45:59',1,'2015-11-01 17:11:02','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10408,1,1,'0010','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0010','财务处','','','','',NULL,NULL,'1','1',1,'2015-07-03 13:46:10',1,'2015-08-27 13:26:50','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10448,1,1,'0006','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0006','院领导','','','','',NULL,NULL,'1','1',1,'2015-07-03 13:46:13',1,'2015-08-27 10:54:57','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (10449,1,1,'0008','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','0008','科主任','','','','',NULL,NULL,'1','1',1,'2015-07-03 13:46:13',1,'2015-08-27 11:37:10','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert  into `sys_user`(`id`,`company_id`,`office_id`,`login_name`,`password`,`no`,`name`,`email`,`phone`,`mobile`,`user_type`,`login_ip`,`login_date`,`job_title`,`education`,`create_by`,`create_date`,`update_by`,`update_date`,`remarks`,`del_flag`,`init_info`,`init_psw`,`birthday`,`degree`,`sex`,`prefression`,`title`,`educational_background`,`graduate_advisor`,`professional_title`,`is_professional`) values (11471,1,1,'3718','f7f833669ed591b1770652aa97993433c84ee7f74dd8a75306318cd0','3718','科教一','','','','',NULL,NULL,'1','1',1,'2015-07-03 13:47:07',1,'2015-08-27 10:53:18','','0',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `sys_user_role` */

CREATE TABLE `sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户编号',
  `role_id` bigint(20) NOT NULL COMMENT '角色编号',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-角色';

/*Data for the table `sys_user_role` */

insert  into `sys_user_role`(`user_id`,`role_id`) values (1,1);
insert  into `sys_user_role`(`user_id`,`role_id`) values (1,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (1,9);
insert  into `sys_user_role`(`user_id`,`role_id`) values (1,10);
insert  into `sys_user_role`(`user_id`,`role_id`) values (1,11);
insert  into `sys_user_role`(`user_id`,`role_id`) values (1,12);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10000,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10001,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10002,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10003,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10004,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10005,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10006,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10007,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10008,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10009,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10223,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10223,9);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10408,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10408,11);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10448,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10448,10);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10449,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (10449,12);
insert  into `sys_user_role`(`user_id`,`role_id`) values (11471,8);
insert  into `sys_user_role`(`user_id`,`role_id`) values (11471,9);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
