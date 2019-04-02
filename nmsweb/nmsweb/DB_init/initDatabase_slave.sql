/*
Navicat MySQL Data Transfer

Source Server         : 192.168.10.186
Source Server Version : 100214
Source Host           : 192.168.10.186:3306
Source Database       : nms

Target Server Type    : MYSQL
Target Server Version : 100214
File Encoding         : 65001

Date: 2018-11-12 15:16:30
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for check_type_info
-- ----------------------------
DROP TABLE IF EXISTS `check_type_info`;
CREATE TABLE `check_type_info` (
  `ID` bigint(20) NOT NULL DEFAULT 0,
  `CHECK_TYPE_NAME` varchar(64) DEFAULT '' COMMENT '检测类别（只能使用26个字母和数字，不区分大小写，在监控信息交互方面与设置名称用于Server向Client端发送映射关系如：cpu：detect_info_cpu）',
  `CHECK_PARAM_VALUE` varchar(64) DEFAULT '' COMMENT '监测描述',
  `CHECK_REMARK` varchar(200) DEFAULT '' COMMENT '备注',
  `TABLE_NAME` varchar(50) DEFAULT '' COMMENT 'CHECK_TYPE_NAME对应的的表名',
  `CRETE_STATE` varchar(1) DEFAULT '' COMMENT '表是否生成标识0已生成或已创建；1未生成；2停用 默认1',
  `TABLE_DESC` text DEFAULT NULL COMMENT 'CHECK_TYPE_NAME对应的的表描述',
  `IS_SCHEDULE` varchar(1) DEFAULT '' COMMENT '监测类型： 0预置监测类型，1三方监测类型，2页面不显示（如snmp_trap）',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  `VIEW_LEVEL` bigint(22) DEFAULT NULL COMMENT '查看范围取值范围[1、4]1-发布人查看2-发布人所在组查看3-系统内全部人员可看4-无限制',
  `GROUP_ID` bigint(22) DEFAULT NULL COMMENT '用户组id',
  `USER_ID` bigint(22) DEFAULT NULL COMMENT '用户id',
  `SYSTEM_ID` bigint(22) DEFAULT NULL COMMENT '业务系统id',
  `IS_SNMP` bigint(22) DEFAULT NULL COMMENT '是否是SNMP 监控，标识从属于字段IS_SCHEDULE的1三方监测类型：0，是ObjectSNMP监控 1，是SNMP4J监控，2 或null否  默认null',
  `OID` varchar(200) DEFAULT '' COMMENT '对应监测oid',
  `CHECK_TYPE_NAME1` varchar(64) DEFAULT '' COMMENT '监测类别名称（不区分大小写）',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监测类别';

-- ----------------------------
-- Table structure for data_police_relation
-- ----------------------------
DROP TABLE IF EXISTS `data_police_relation`;
CREATE TABLE `data_police_relation` (
  `ID` bigint(20) NOT NULL DEFAULT 0,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id外键',
  `METADATA_ID` bigint(22) DEFAULT NULL COMMENT '字段id',
  `POLICE_STATE` varchar(1) DEFAULT '' COMMENT '是否用于报警：是否用于报警	0启用，1停用',
  `POLICE_VALUE` text DEFAULT NULL COMMENT '报警值',
  `POLICE_UNIT` varchar(22) DEFAULT '' COMMENT '报警值单位：如%等',
  `POLICE_SYMBOLS` varchar(10) DEFAULT '' COMMENT '报警比较符：针对number型数据>、<、>=、<=、=针对字符串类型数据equal、 include、exclude',
  `POLICE_LEVEL` bigint(22) DEFAULT NULL COMMENT '报警级别',
  `POLICE_SHOW_INFO` varchar(200) DEFAULT '' COMMENT '报警提示信息',
  `POLICE_EMERGENT` bigint(22) DEFAULT NULL COMMENT '告警是否紧急 0：紧急  1：非紧急',
  `MARKER` text DEFAULT NULL COMMENT '设置告警时，指定多个标识符（如多个盘符、多个CPU、多个网卡），如硬盘使用率，空：所有盘存在一个盘使用率超过告警值，则告警；all：所有盘总的使用率超过告警值，则告警；指定多个盘符：指定盘存在一个盘使用率超过告警值，则告警',
  `MARKER_FILED_ID` bigint(22) DEFAULT NULL COMMENT '设置告警时，过滤标识marker对应的字段在metadata表中的id。',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监测数据报警关系表';

-- ----------------------------
-- Table structure for delect_info_nmsc
-- ----------------------------
DROP TABLE IF EXISTS `delect_info_nmsc`;
CREATE TABLE `delect_info_nmsc` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `SEND_INFO` varchar(100) DEFAULT '' COMMENT '发送信息',
  `RETURN_INFO` varchar(100) DEFAULT '' COMMENT '返回信息',
  `IS_IDENTICAL` bigint(22) DEFAULT NULL COMMENT '是否可达',
  `SEND_TIME` datetime DEFAULT NULL COMMENT '发送时间',
  `RETURN_TIME` datetime DEFAULT NULL COMMENT '返回时间',
  `DELAY_TIME` bigint(22) DEFAULT NULL COMMENT '延迟时间',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DELECT_INFO_NMSC_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `INDEX_DET_NMSC_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DET_NMSC_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9487 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detection_info
-- ----------------------------
DROP TABLE IF EXISTS `detection_info`;
CREATE TABLE `detection_info` (
  `ID` bigint(20) NOT NULL DEFAULT 0,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id，外键',
  `CHECK_WAY` varchar(1) DEFAULT '' COMMENT '监测方式不能为空，可选[0/1]0主动、1被动（设置为主动可能本记录为被动）',
  `DETECTION_STATE_INFO` text DEFAULT NULL COMMENT '状态信息',
  `PERFORMACE_DATA` text DEFAULT NULL COMMENT '性能数据',
  `CURRENT_TIMES` bigint(22) DEFAULT NULL COMMENT '当前尝试次数',
  `START_TIME` datetime DEFAULT NULL COMMENT '开运时间',
  `WAIT_TIME` bigint(22) DEFAULT NULL COMMENT '检测等待时间单位秒',
  `DELAY_TIME` bigint(22) DEFAULT NULL COMMENT '检测时延单位秒',
  `NEXT_CHECK_TIME` datetime DEFAULT NULL COMMENT '下一次计划主动式检测时间',
  `OFF_LINE` datetime DEFAULT NULL COMMENT '计划宕机时间',
  `POLICE_LEVEL` bigint(22) DEFAULT NULL COMMENT '预警级别',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DETECTIONED_STATE` varchar(2) DEFAULT '' COMMENT '被监控状态是否正常：-1执行不成功；0不正常；1正常',
  `NODE_IP` varchar(64) DEFAULT '' COMMENT '主机ip，标识主机位置',
  `STATUS_CHANGE_TIME` datetime DEFAULT NULL COMMENT '监控状态最后一次变化时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间 数字类型',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间 数字类型',
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理节点唯一标识',
  `POLICE_EMERGENT` bigint(22) DEFAULT NULL COMMENT '告警是否紧急 0：紧急  1：非紧急',
  `INSERT_DB_TIME` datetime DEFAULT NULL COMMENT '入库时间',
  `SEQUENCE` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '序号',
  PRIMARY KEY (`SEQUENCE`,`DATA_CHECK_TIME`,`ID`),
  KEY `DETECTION_INFO_DATA_CHECK_TIME` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `INDEX_DI_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DI_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=91975 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detection_info_new
-- ----------------------------
DROP TABLE IF EXISTS `detection_info_new`;
CREATE TABLE `detection_info_new` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id，外键',
  `CHECK_WAY` varchar(1) DEFAULT '' COMMENT '监测方式不能为空，可选[0/1]0主动、1被动（设置为主动可能本记录为被动）',
  `DETECTION_STATE_INFO` text DEFAULT NULL COMMENT '状态信息',
  `PERFORMACE_DATA` text DEFAULT NULL COMMENT '性能数据',
  `CURRENT_TIMES` bigint(22) DEFAULT NULL COMMENT '当前尝试次数',
  `START_TIME` datetime DEFAULT NULL COMMENT '开运时间',
  `WAIT_TIME` bigint(22) DEFAULT NULL COMMENT '检测等待时间单位秒',
  `DELAY_TIME` bigint(22) DEFAULT NULL COMMENT '检测时延单位秒',
  `NEXT_CHECK_TIME` datetime DEFAULT NULL COMMENT '下一次计划主动式检测时间',
  `OFF_LINE` datetime DEFAULT NULL COMMENT '计划宕机时间',
  `POLICE_LEVEL` bigint(22) DEFAULT NULL COMMENT '预警级别',
  `DATA_CHECK_TIME` datetime DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DETECTIONED_STATE` varchar(2) DEFAULT '' COMMENT '被监控状态是否正常：0不正常；1正常',
  `NODE_IP` varchar(64) DEFAULT '' COMMENT '主机ip，标识主机位置',
  `STATUS_CHANGE_TIME` datetime DEFAULT NULL COMMENT '监控状态最后一次变化时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间 数字类型',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间 数字类型',
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理节点唯一标识',
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL COMMENT 'detection_info表主键',
  `VALID` bigint(22) DEFAULT 1 COMMENT '监测数据是否有效，1有效，0无效，默认有效',
  `POLICE_EMERGENT` bigint(22) DEFAULT 1 COMMENT '告警是否紧急 0：紧急  1：非紧急',
  PRIMARY KEY (`ID`),
  KEY `DETECTION_INFO_NEW_CT` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `FK_DETECTION_SET_INFO_NEW` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监控数据表(最新数据:最后一次监测数据信息表)';

-- ----------------------------
-- Table structure for detection_info_warning
-- ----------------------------
DROP TABLE IF EXISTS `detection_info_warning`;
CREATE TABLE `detection_info_warning` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id，外键',
  `CHECK_WAY` varchar(1) DEFAULT '' COMMENT '监测方式不能为空，可选[0/1]0主动、1被动（设置为主动可能本记录为被动）',
  `DETECTION_STATE_INFO` text DEFAULT NULL COMMENT '状态信息',
  `PERFORMACE_DATA` text DEFAULT NULL COMMENT '性能数据',
  `CURRENT_TIMES` bigint(22) DEFAULT NULL COMMENT '当前尝试次数',
  `START_TIME` datetime DEFAULT NULL COMMENT '开机时间（开运时间）',
  `WAIT_TIME` bigint(22) DEFAULT NULL COMMENT '检测等待时间单位秒',
  `DELAY_TIME` bigint(22) DEFAULT NULL COMMENT '检测时延单位秒',
  `NEXT_CHECK_TIME` datetime DEFAULT NULL COMMENT '下一次计划主动式检测时间',
  `OFF_LINE` datetime DEFAULT NULL COMMENT '计划宕机时间',
  `POLICE_LEVEL` bigint(22) DEFAULT NULL COMMENT '预警级别',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `NOTICE_FLAG` varchar(1) DEFAULT '' COMMENT '是否已发通知:0未发；1已发',
  `DETECTIONED_STATE` varchar(2) DEFAULT '' COMMENT '被监控状态是否正常：0不正常；1正常',
  `NOTICE_INFO` text DEFAULT NULL COMMENT '警告信息',
  `NODE_IP` varchar(64) DEFAULT '' COMMENT '主机ip，标识主机位置',
  `STATUS_CHANGE_TIME` datetime DEFAULT NULL COMMENT '监控状态最后一次变化时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间 数字类型',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间 数字类型',
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理节点唯一标识',
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL COMMENT 'detection_info表主键',
  `VALID` int(22) DEFAULT 1 COMMENT '告警数据是否有效，1有效，0无效，默认有效',
  `POLICE_EMERGENT` int(22) DEFAULT 1 COMMENT '告警是否紧急 0：紧急  1：非紧急',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECTION_INFO_WARNING_CT` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `INDEX_DIW_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DIW_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=173211174700099010 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监控数据表(需警告数据)'
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detection_set_info
-- ----------------------------
DROP TABLE IF EXISTS `detection_set_info`;
CREATE TABLE `detection_set_info` (
  `ID` bigint(20) NOT NULL DEFAULT 0,
  `NODE_IP` text DEFAULT NULL COMMENT '主机ip，标识主机位置',
  `CHECK_TYPE_ID` bigint(22) DEFAULT NULL COMMENT '外键对应check_type_info表的id；监测类别id:监测类别：ping；cpu;硬盘；内存；软件进程等等对应的id',
  `CHECK_GAP` bigint(22) DEFAULT NULL COMMENT '监测时间间隔单位分钟：不能为空，默认15分钟。监测在设置后获取一次数据，然后按间隔获取；如果只监测一次，把时间设置足够长',
  `CHECK_WAY` varchar(1) DEFAULT '' COMMENT '监测方式：0，1；不能为空，默认1被动',
  `CHECK_OUT_TIME` bigint(22) DEFAULT NULL COMMENT '超时时间(单位秒)：0为无限制，默认值为0',
  `CHECK_MAX_TIMES` bigint(22) DEFAULT NULL COMMENT '最大测试次数：如果第一次不成功，重新执行最大次数',
  `PROCESS_IDEN` varchar(50) DEFAULT '' COMMENT '设置标识（只能使用26个字母和数字，不区分大小写，在监控信息交互方面与检测类别用于Server向Client端发送映射关系如：cpu：detect_info_cpu）',
  `DETECTION_SET_STATE` varchar(1) DEFAULT '' COMMENT '监测设置的状态0无效；1有效;是否有效，如果有效按设置执行监测，否则不再执行该监测',
  `PROCESS_FILE` varchar(64) DEFAULT '' COMMENT '进程名称',
  `PROCESS_PATH` varchar(64) DEFAULT '' COMMENT '进程执行文件路径',
  `OID` varchar(100) DEFAULT '' COMMENT 'OID：SNMP对应的OID',
  `IS_CONTROL_START` varchar(1) DEFAULT '' COMMENT '是否系统启动（NMSAgent启动/第三方自己启动）；默认0手工启动；1NCt启动',
  `IS_ISSUE_FILE` varchar(1) DEFAULT '' COMMENT '是否需下发文件：0需要；1不需要 默认1',
  `IS_ISSUED` varchar(1) DEFAULT '' COMMENT '文件下发是否成功;0成功；1不成功 默认1',
  `CONTROL_START_TIME` datetime DEFAULT NULL COMMENT '控制启动时间',
  `UPLOAD_GAP` bigint(22) DEFAULT NULL COMMENT '上传数据时间间隔单位分钟：不能为空，默认15分钟。监测数据上传到NMSServer周期',
  `IS_ISSUE` varchar(1) DEFAULT '' COMMENT '是否下发设置：0下发；1未下发 默认值为1如新添加或者修改一项设置之后设置为未下发，需要完成其他配置信息后才执行一次下发',
  `PLAN_CHECK_TIME` datetime DEFAULT NULL COMMENT '计划检测时间:针对当前配置信息首次执行时间',
  `GROUP_ID` int(11) DEFAULT NULL COMMENT '节点组ID',
  `VIEW_LEVEL` bigint(22) DEFAULT NULL COMMENT '查看级别1个人2组内3系统内4无限制',
  `CONTACT_USER_IDS` text DEFAULT NULL COMMENT '联系人ID,逗号间隔',
  `CREATE_USER_ID` bigint(22) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USERGROUP_ID` bigint(22) DEFAULT NULL COMMENT '创建者所在用户组ID',
  `SYSTEM_ID` bigint(22) DEFAULT NULL COMMENT '系统ID',
  `NODE_GROUPS_ID` varchar(500) DEFAULT '' COMMENT '设置的有效节点组范围',
  `NODE_IPS_ID` varchar(500) DEFAULT '' COMMENT '设置的有效节点范围。如果有NODES_IP有值则不管节点组的有效范围；如果NODES_IP无值则使用节点组的范围；如果NODES_IP和NODE_GROUPS_ID均为空则有效范围是SYSTEM_ID系统内全部有效节点；如果三者均为空则有效范围为NMS系统内全部有效节点',
  `PROCESS_IDEN_NAME` varchar(64) DEFAULT '' COMMENT '设置名称：如果是进程则是进程标识.进程标识，根据标识获取相应的进程信息',
  `PROCESS_SEARCH_KEYCODE` varchar(100) DEFAULT '' COMMENT '进程搜索关键字  用于NC进程监测',
  PRIMARY KEY (`ID`),
  KEY `GROUP_ID` (`GROUP_ID`) USING BTREE,
  CONSTRAINT `detection_set_info_ibfk_1` FOREIGN KEY (`GROUP_ID`) REFERENCES `nodegroup_table` (`group_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监测设置表';

-- ----------------------------
-- Table structure for detect_info_cpu
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_cpu`;
CREATE TABLE `detect_info_cpu` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `USER_USED_CPU_PERC` bigint(22) DEFAULT NULL COMMENT '用户使用率(us%)',
  `SYS_USED_CPU_PERC` bigint(22) DEFAULT NULL COMMENT '系统使用率(sy%)',
  `WAIT_CPU_PERC` bigint(22) DEFAULT NULL COMMENT '当前等待率(wa%)',
  `NICE_PERC` bigint(22) DEFAULT NULL COMMENT '用户空间进程CPU占用比(ni%)',
  `FREE_CPU_PERC` bigint(22) DEFAULT NULL COMMENT '当前空闲率(id%)',
  `TOTAL_USED_PERC` bigint(22) DEFAULT NULL COMMENT '总的使用率(%)',
  `CPU_MHZ` bigint(22) DEFAULT NULL COMMENT '主频',
  `CPU_NAME` varchar(100) DEFAULT '' COMMENT 'cpu标识',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_CPU_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_CPU_2` (`USER_USED_CPU_PERC`) USING BTREE,
  KEY `DETECT_INFO_CPU_3` (`SYS_USED_CPU_PERC`) USING BTREE,
  KEY `DETECT_INFO_CPU_4` (`WAIT_CPU_PERC`) USING BTREE,
  KEY `DETECT_INFO_CPU_5` (`NICE_PERC`) USING BTREE,
  KEY `DETECT_INFO_CPU_6` (`FREE_CPU_PERC`) USING BTREE,
  KEY `DETECT_INFO_CPU_7` (`TOTAL_USED_PERC`) USING BTREE,
  KEY `INDEX_DET_CPU_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DET_CPU_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=70494 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_disk
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_disk`;
CREATE TABLE `detect_info_disk` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `DISK_RANGE` varchar(50) DEFAULT '' COMMENT '磁盘',
  `TOTAL_DISK_SIZE` bigint(22) DEFAULT NULL COMMENT '磁盘总容量(G)',
  `FREE_DISK_SIZE` bigint(22) DEFAULT NULL COMMENT '磁盘空闲容量(G)',
  `USED_DISK_PERC` bigint(22) DEFAULT NULL COMMENT '磁盘使用率(%)',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `DISK_ISWRITE` bigint(22) DEFAULT NULL COMMENT '磁盘是否可写',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_DISK_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_DISK_2` (`FREE_DISK_SIZE`) USING BTREE,
  KEY `DETECT_INFO_DISK_3` (`USED_DISK_PERC`) USING BTREE,
  KEY `INDEX_DET_DISK_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DET_DISK_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23091 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_memory
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_memory`;
CREATE TABLE `detect_info_memory` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `FREE_SPACE_INPAGING_FILES` bigint(22) DEFAULT NULL COMMENT '可用交换空间(swapfreeG)',
  `SIZE_STOREDINPAGING_FILES` bigint(22) DEFAULT NULL COMMENT '总交换空间(swaptotalG)',
  `TOTAL_MEMORY_SIZE` bigint(22) DEFAULT NULL COMMENT '总内存(totalG)',
  `USED_MEMORY_SIZE` bigint(22) DEFAULT NULL COMMENT '已用内存(usedG)',
  `FREE_MEMORY_SIZE` bigint(22) DEFAULT NULL COMMENT '空闲内存(freeG)',
  `USED_MEMORY_PERC` bigint(22) DEFAULT NULL COMMENT '内存使用率(%)',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_MEMORY_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_MEMORY_2` (`FREE_SPACE_INPAGING_FILES`) USING BTREE,
  KEY `DETECT_INFO_MEMORY_3` (`USED_MEMORY_PERC`) USING BTREE,
  KEY `INDEX_DET_MEM_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DET_MEM_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9325 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_netdata
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_netdata`;
CREATE TABLE `detect_info_netdata` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `RX_PACKETS` bigint(22) DEFAULT NULL COMMENT '接收的总包裹数',
  `TX_PACKETS` bigint(22) DEFAULT NULL COMMENT '发送的总包裹数',
  `RX_BYTES` bigint(22) DEFAULT NULL COMMENT '接收到的总字节数',
  `TX_BYTES` bigint(22) DEFAULT NULL COMMENT '发送的总字节数',
  `RX_ERRORS` bigint(22) DEFAULT NULL COMMENT '接收到的错误包数',
  `TX_ERRORS` bigint(22) DEFAULT NULL COMMENT '发送数据包时的错误数',
  `RX_DROPPED` bigint(22) DEFAULT NULL COMMENT '接收时丢弃的包数',
  `TX_DROPPED` bigint(22) DEFAULT NULL COMMENT '发送时丢弃的包数',
  `SPEED` bigint(22) DEFAULT NULL COMMENT '带宽（单位：Mbps）',
  `RX_BPS` bigint(22) DEFAULT NULL COMMENT '输入bps（单位：bps）',
  `TX_BPS` bigint(22) DEFAULT NULL COMMENT '输出bps（单位：bps）',
  `RX_PPS` bigint(22) DEFAULT NULL COMMENT '输入pps（每秒接收包数）',
  `TX_PPS` bigint(22) DEFAULT NULL COMMENT '输出pps（每秒发出包数）',
  `NAME` varchar(200) DEFAULT '' COMMENT '网卡名称',
  `RX_ERRORS_PERC` bigint(22) DEFAULT NULL COMMENT '接收错包率',
  `TX_ERRORS_PERC` bigint(22) DEFAULT NULL COMMENT '发送错包率',
  `RX_DROP_PERC` bigint(22) DEFAULT NULL COMMENT '接收丢包率',
  `TX_DROP_PERC` bigint(22) DEFAULT NULL COMMENT '发送丢包率',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_NETDATA_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_2` (`RX_PACKETS`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_3` (`TX_PACKETS`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_4` (`RX_BYTES`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_5` (`TX_BYTES`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_6` (`RX_ERRORS`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_7` (`TX_ERRORS`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_8` (`RX_DROPPED`) USING BTREE,
  KEY `DETECT_INFO_NETDATA_9` (`TX_DROPPED`) USING BTREE,
  KEY `INDEX_DET_NETDATA_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DET_NETDATA_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32223 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_ping
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_ping`;
CREATE TABLE `detect_info_ping` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `PACKETS_SEND` bigint(22) DEFAULT NULL COMMENT '已发送包数',
  `PACKETS_RECEIVED` bigint(22) DEFAULT NULL COMMENT '已接受包数',
  `PACKETS_LOST` bigint(22) DEFAULT NULL COMMENT '丢包个数',
  `PACKETS_LOST_RATE` bigint(22) DEFAULT NULL COMMENT '丢包率',
  `TIME_CONSUMING_MIN` bigint(22) DEFAULT NULL COMMENT '最短耗时（单位毫秒）',
  `TIME_CONSUMING_MAX` bigint(22) DEFAULT NULL COMMENT '最长耗时（单位毫秒）',
  `TIME_CONSUMING_AVER` bigint(22) DEFAULT NULL COMMENT '平均耗时（单位毫秒）',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_PING_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_PING_2` (`PACKETS_LOST_RATE`) USING BTREE,
  KEY `DETECT_INFO_PING_3` (`TIME_CONSUMING_AVER`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11529 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_port
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_port`;
CREATE TABLE `detect_info_port` (
  `DETECTION_INFO_ID` bigint(20) NOT NULL DEFAULT 0,
  `RX_BYTES` bigint(22) DEFAULT NULL,
  `TX_BYTES` bigint(22) DEFAULT NULL,
  `RX_PPS` bigint(22) DEFAULT NULL,
  `TX_PPS` bigint(22) DEFAULT NULL,
  `RX_DROP_PERC` bigint(22) DEFAULT NULL,
  `TX_DROP_PERC` bigint(22) DEFAULT NULL,
  `RX_BPS` bigint(22) DEFAULT NULL,
  `TX_BPS` bigint(22) DEFAULT NULL,
  `RX_DROPPED` bigint(22) DEFAULT NULL,
  `TX_DROPPED` bigint(22) DEFAULT NULL,
  `PORT_STATE` bigint(22) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  `DATA_CHECK_TIME` datetime NOT NULL,
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL,
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `INTERFACE_NAME` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`DETECTION_INFO_ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_PORT_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_PORT_2` (`SEQ_ID`) USING BTREE,
  KEY `DETECT_INFO_PORT_3` (`DETECTION_SET_INFO_ID`) USING BTREE,
  KEY `DETECT_INFO_PORT_4` (`RX_BPS`) USING BTREE,
  KEY `DETECT_INFO_PORT_5` (`TX_BPS`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_process
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_process`;
CREATE TABLE `detect_info_process` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `CPU_USED_PERC` bigint(22) DEFAULT NULL COMMENT '进程的CPU使用率',
  `MEM_USED_PERC` bigint(22) DEFAULT NULL COMMENT '进程的内存使用率',
  `PRO_START_TIME` datetime DEFAULT NULL COMMENT '进程启动时间',
  `PROC_STATE` varchar(2) DEFAULT '' COMMENT '进程的状态',
  `PROC_PRIORITY` bigint(22) DEFAULT NULL COMMENT '进程的优先级',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_PROCESS_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DETECT_INFO_PROCESS_2` (`CPU_USED_PERC`) USING BTREE,
  KEY `DETECT_INFO_PROCESS_3` (`MEM_USED_PERC`) USING BTREE,
  KEY `INDEX_DET_PROCESS_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DET_PROCESS_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_snmp_trap
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_snmp_trap`;
CREATE TABLE `detect_info_snmp_trap` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `AGENT_SEND_IP` varchar(20) DEFAULT NULL,
  `PDU_AGENT_IP` varchar(20) DEFAULT NULL,
  `RECEIVER_TIME` bigint(22) DEFAULT NULL,
  `TRAP_VERSION` bigint(22) DEFAULT NULL,
  `GENERIC_TYPE` bigint(22) DEFAULT NULL,
  `SPECIFIC_TYPE` bigint(22) DEFAULT NULL,
  `TRAP_NAME` varchar(200) DEFAULT NULL,
  `TRAP_OID` varchar(200) DEFAULT NULL,
  `TRAP_PDU_OIDS` text DEFAULT NULL,
  `TRAP_PDU_OID_V` text DEFAULT NULL,
  `ORIGINAL_PDU` text DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL,
  `DATA_CHECK_TIME` datetime NOT NULL,
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL,
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for detect_info_system_date
-- ----------------------------
DROP TABLE IF EXISTS `detect_info_system_date`;
CREATE TABLE `detect_info_system_date` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `SERVICE_DATE` datetime DEFAULT NULL COMMENT '服务机时间',
  `DETECT_DATE` datetime DEFAULT NULL COMMENT '监控机时间',
  `TIME_DELAY` bigint(22) DEFAULT NULL COMMENT '时间差（单位：分钟）',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DETECT_INFO_SYSTEM_DATE_1` (`DATA_CHECK_TIME`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9263 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for device_boardsolt_board
-- ----------------------------
DROP TABLE IF EXISTS `device_boardsolt_board`;
CREATE TABLE `device_boardsolt_board` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `device_brand_code` varchar(64) DEFAULT '' COMMENT '品牌code',
  `device_board_solt_code` varchar(64) DEFAULT '' COMMENT '槽位code',
  `device_board_code` varchar(64) DEFAULT '' COMMENT '板卡code',
  `device_type_code` varchar(64) DEFAULT '' COMMENT '设备型号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='设备板槽板子对应关系表，每个板槽都可用放什么板子';

-- ----------------------------
-- Table structure for device_brand_info
-- ----------------------------
DROP TABLE IF EXISTS `device_brand_info`;
CREATE TABLE `device_brand_info` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `device_rand_code` varchar(64) NOT NULL COMMENT '设备品牌代码，不重复',
  `device_rand_name` varchar(100) NOT NULL COMMENT '设备品牌',
  `device_brand_desc` varchar(500) DEFAULT '' COMMENT '描述信息',
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  `add_userid` int(11) DEFAULT NULL COMMENT '添加人',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后更改时间',
  `last_update_userid` int(11) DEFAULT NULL COMMENT '最后更改人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='设备品牌表';

-- ----------------------------
-- Table structure for device_brand_type
-- ----------------------------
DROP TABLE IF EXISTS `device_brand_type`;
CREATE TABLE `device_brand_type` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `device_brand_code` varchar(64) DEFAULT '' COMMENT '设备品牌代码',
  `par_device_type_code` varchar(64) DEFAULT '' COMMENT '设备代码',
  `sub_device_type_code` varchar(64) DEFAULT '' COMMENT '设备板子代码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='设备品牌板子类型对应表多对多';

-- ----------------------------
-- Table structure for device_info
-- ----------------------------
DROP TABLE IF EXISTS `device_info`;
CREATE TABLE `device_info` (
  `device_id` bigint(20) NOT NULL DEFAULT 0,
  `device_locate` varchar(8) NOT NULL,
  `device_made` varchar(3) NOT NULL,
  `device_type` varchar(3) NOT NULL,
  `commu_addr` varchar(16) NOT NULL,
  `commu_mac` varchar(18) NOT NULL,
  `commu_mask` varchar(16) NOT NULL,
  `commu_gateway` varchar(16) NOT NULL,
  `manage_addr` varchar(16) NOT NULL,
  `manage_mac` varchar(18) NOT NULL,
  `manage_mask` varchar(16) NOT NULL,
  `manage_gateway` varchar(16) NOT NULL,
  `center_ip1` varchar(16) NOT NULL,
  `center_ip2` varchar(16) NOT NULL,
  `soft_version` varchar(18) DEFAULT NULL,
  `dns_version` varchar(18) DEFAULT NULL,
  `ip_version` varchar(18) DEFAULT NULL,
  `swip_version` varchar(18) DEFAULT NULL,
  `geoip_version` varchar(18) DEFAULT NULL,
  `sen_version` varchar(18) DEFAULT NULL,
  `spe_version` varchar(18) DEFAULT NULL,
  `mail_version` varchar(18) DEFAULT NULL,
  `own_version` varchar(18) DEFAULT NULL,
  `commu_interface` varchar(18) DEFAULT NULL,
  `manage_interface` varchar(18) DEFAULT NULL,
  `insititue` varchar(18) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for device_type_info
-- ----------------------------
DROP TABLE IF EXISTS `device_type_info`;
CREATE TABLE `device_type_info` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `device_type_code` varchar(100) NOT NULL COMMENT '设备型号，不重复',
  `device_rand_code` varchar(64) NOT NULL COMMENT '设备品牌代码',
  `device_desc` varchar(500) DEFAULT '' COMMENT '描述信息',
  `show_index` decimal(22,0) DEFAULT NULL COMMENT '级别下位置序号，注意从0还是从1开始',
  `pid` varchar(100) DEFAULT '' COMMENT '父级标识（Device_type_code）',
  `figure_type` varchar(64) NOT NULL COMMENT '图片类型，rect、circle、image等svg图形类型',
  `figure_x` decimal(22,0) DEFAULT NULL COMMENT 'X坐标',
  `figure_y` decimal(22,0) DEFAULT NULL COMMENT 'Y坐标',
  `figure_width` decimal(22,0) DEFAULT NULL COMMENT '宽',
  `figure_height` decimal(22,0) DEFAULT NULL COMMENT '高',
  `figure_stroke` varchar(20) DEFAULT '' COMMENT '边颜色',
  `figure_stroke_width` decimal(22,0) DEFAULT NULL COMMENT '边宽',
  `figure_fill` varchar(100) DEFAULT '' COMMENT '填充色：图形为填充色；image为xlink:href内容',
  `name_format` varchar(64) DEFAULT '' COMMENT '命名格式：Name[x]/[y]其中的x(板卡位置)y（端口位置）是要替换的内容',
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  `add_userid` int(11) DEFAULT NULL COMMENT '添加人',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后更改时间',
  `last_update_userid` int(11) DEFAULT NULL COMMENT '最后更改人',
  `di_table_name` varchar(50) DEFAULT NULL,
  `index_filed` varchar(64) DEFAULT NULL,
  `status_filed` varchar(64) DEFAULT NULL,
  `status_symbols` varchar(10) DEFAULT NULL,
  `status_value` varchar(64) DEFAULT NULL,
  `show_level` decimal(22,0) DEFAULT NULL COMMENT '图形级别，最多支持5级',
  `is_link` decimal(22,0) DEFAULT NULL COMMENT '是否有链接，1是，0否，对应node_figure_info表的IS_LEAF字段',
  `is_leaf` decimal(22,0) DEFAULT NULL COMMENT '是否叶子设备（叶子设备不会再有设备接到它上面），1是，0否，',
  `max_device_num` decimal(22,0) DEFAULT 1 COMMENT '设备最大叠加数',
  `is_positiondev` decimal(22,0) DEFAULT 0 COMMENT '是否为槽位设备，1是，0否',
  `has_instance` decimal(22,0) DEFAULT 1 COMMENT '是否配置实例，1是，0否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='设备型号表';

-- ----------------------------
-- Table structure for dictionary_table
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_table`;
CREATE TABLE `dictionary_table` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `type_nmae` varchar(64) DEFAULT '' COMMENT '名称',
  `type_desc` varchar(256) DEFAULT '' COMMENT '描述',
  `type_state` decimal(22,0) DEFAULT NULL COMMENT '状态',
  `type_value` decimal(22,0) DEFAULT NULL COMMENT '值',
  `type_mark` varchar(16) DEFAULT '' COMMENT '类别标识（预留）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='基本数据字典表，定义字典类别';

-- ----------------------------
-- Table structure for di_base_info
-- ----------------------------
DROP TABLE IF EXISTS `di_base_info`;
CREATE TABLE `di_base_info` (
  `DETECTION_INFO_ID` bigint(20) NOT NULL DEFAULT 0,
  `IP` varchar(32) DEFAULT NULL,
  `NETCARD_NUM` varchar(32) DEFAULT NULL,
  `BUSINESS_IP` varchar(32) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  `DATA_CHECK_TIME` datetime NOT NULL,
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL,
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  PRIMARY KEY (`DETECTION_INFO_ID`,`DATA_CHECK_TIME`),
  KEY `DI_BASE_INFO_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DI_BASE_INFO_2` (`SEQ_ID`) USING BTREE,
  KEY `DI_BASE_INFO_3` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_businesspro
-- ----------------------------
DROP TABLE IF EXISTS `di_businesspro`;
CREATE TABLE `di_businesspro` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_info_id` bigint(20) NOT NULL,
  `module` varchar(32) DEFAULT '' COMMENT '进程所属业务进程',
  `pid` bigint(20) DEFAULT NULL COMMENT '进程号',
  `cpupct` decimal(20,2) DEFAULT NULL COMMENT 'cpu占用百分比',
  `mempct` decimal(20,2) DEFAULT NULL COMMENT '内存占用百分比',
  `prostatus` varchar(8) DEFAULT '' COMMENT '进程状态',
  `propriority` bigint(20) DEFAULT NULL COMMENT '进程调度优先级',
  `lstart` varchar(128) DEFAULT '' COMMENT '进程启动时间',
  `iscritical` varchar(128) DEFAULT '' COMMENT '最近是否有关键日志产生',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` int(11) DEFAULT NULL COMMENT '物理位置节点',
  `DETECTION_SET_INFO_ID` bigint(20) DEFAULT NULL,
  `data_check_time` datetime NOT NULL COMMENT '获取监测数据时间',
  `data_arrive_time` datetime DEFAULT NULL COMMENT '数据入库时间',
  `data_check_time_digital` bigint(20) DEFAULT NULL COMMENT '获取监测数据时间',
  `data_arrive_time_digital` bigint(20) DEFAULT NULL COMMENT '数据入库时间',
  PRIMARY KEY (`ID`,`data_check_time`),
  KEY `DI_BUSINESSPRO_1` (`data_check_time`),
  KEY `DI_BUSINESSPRO_2` (`SEQ_ID`),
  KEY `DI_BUSINESSPRO_3` (`DETECTION_SET_INFO_ID`),
  KEY `DI_BUSINESSPRO_4` (`cpupct`),
  KEY `DI_BUSINESSPRO_5` (`mempct`)
) ENGINE=InnoDB AUTO_INCREMENT=12230 DEFAULT CHARSET=utf8
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_c3glog
-- ----------------------------
DROP TABLE IF EXISTS `di_c3glog`;
CREATE TABLE `di_c3glog` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_info_id` bigint(20) NOT NULL,
  `logpath` varchar(256) DEFAULT NULL,
  `reptime` datetime DEFAULT NULL,
  `c3ip` varchar(32) DEFAULT NULL,
  `gdevip` varchar(32) DEFAULT NULL,
  `repcontent` varchar(256) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` int(11) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(20) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` bigint(20) DEFAULT NULL,
  `data_arrive_time_digital` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`,`data_check_time`),
  KEY `DI_C3GLOG_1` (`data_check_time`),
  KEY `DI_C3GLOG_2` (`SEQ_ID`),
  KEY `DI_C3GLOG_3` (`DETECTION_SET_INFO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=896 DEFAULT CHARSET=utf8
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_dpboardstatusentry
-- ----------------------------
DROP TABLE IF EXISTS `di_dpboardstatusentry`;
CREATE TABLE `di_dpboardstatusentry` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `detection_info_id` int(11) NOT NULL,
  `dpboardtemperature` decimal(22,0) DEFAULT NULL,
  `detectioned_state` varchar(2) DEFAULT NULL,
  `seq_id` int(11) DEFAULT NULL,
  `detection_set_info_id` int(11) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` decimal(22,0) DEFAULT NULL,
  `data_arrive_time_digital` decimal(22,0) DEFAULT NULL,
  PRIMARY KEY (`id`,`data_check_time`),
  KEY `INDEX_DI_DPBORADL_SET_ID` (`detection_set_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_dpslotentry
-- ----------------------------
DROP TABLE IF EXISTS `di_dpslotentry`;
CREATE TABLE `di_dpslotentry` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `detection_info_id` int(11) NOT NULL,
  `dpslotindex` decimal(22,0) DEFAULT NULL COMMENT '设备槽号',
  `dpslottype` decimal(22,0) DEFAULT NULL COMMENT '设备热插拔板子的类型',
  `dpslotdesc` varchar(400) DEFAULT '' COMMENT '设备热插拔板子的描述',
  `dpslotportnum` decimal(22,0) DEFAULT NULL COMMENT '设备热插拔板子的端口数目',
  `dpslotstatus` decimal(22,0) DEFAULT NULL COMMENT '设备槽的状态',
  `dpslotismain` decimal(22,0) DEFAULT NULL COMMENT '设备板子是否为主板',
  `dpslotruntimes` varchar(400) DEFAULT '' COMMENT '设备板子运行的时间',
  `detectioned_state` varchar(2) DEFAULT NULL,
  `seq_id` int(11) DEFAULT NULL COMMENT '物理位置节点',
  `detection_set_info_id` int(11) DEFAULT NULL,
  `data_check_time` datetime NOT NULL COMMENT '获取监测数据时间',
  `data_arrive_time` datetime DEFAULT NULL COMMENT '数据入库时间',
  `data_check_time_digital` decimal(22,0) DEFAULT NULL COMMENT '获取监测数据时间',
  `data_arrive_time_digital` decimal(22,0) DEFAULT NULL COMMENT '数据入库时间',
  PRIMARY KEY (`id`,`data_check_time`),
  KEY `INDEX_DI_DPSLOT_SET_ID` (`detection_set_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_dpsystemfanentry
-- ----------------------------
DROP TABLE IF EXISTS `di_dpsystemfanentry`;
CREATE TABLE `di_dpsystemfanentry` (
  `detection_info_id` int(11) NOT NULL,
  `dpsystemfanno` decimal(22,0) DEFAULT NULL,
  `dpsystemfanstat` varchar(400) DEFAULT NULL,
  `detectioned_state` varchar(2) DEFAULT NULL,
  `seq_id` int(11) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` decimal(22,0) DEFAULT NULL,
  `data_arrive_time_digital` decimal(22,0) DEFAULT NULL,
  `id` bigint(20) NOT NULL DEFAULT 0,
  `detection_set_info_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`data_check_time`),
  KEY `INDEX_DI_DSYSFAN_SET_ID` (`detection_set_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_dpsystempowerentry
-- ----------------------------
DROP TABLE IF EXISTS `di_dpsystempowerentry`;
CREATE TABLE `di_dpsystempowerentry` (
  `detection_info_id` int(11) NOT NULL,
  `dpsystempowerno` decimal(22,0) DEFAULT NULL,
  `dpsystempowerstat` varchar(400) DEFAULT NULL,
  `detectioned_state` varchar(2) DEFAULT NULL,
  `seq_id` int(11) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` decimal(22,0) DEFAULT NULL,
  `data_arrive_time_digital` decimal(22,0) DEFAULT NULL,
  `id` bigint(20) NOT NULL DEFAULT 0,
  `detection_set_info_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`data_check_time`),
  KEY `INDEX_DI_DSYSPOWER_SET_ID` (`detection_set_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_dpsystemstatus
-- ----------------------------
DROP TABLE IF EXISTS `di_dpsystemstatus`;
CREATE TABLE `di_dpsystemstatus` (
  `detection_info_id` int(11) NOT NULL,
  `dpcpuratio` decimal(22,0) DEFAULT NULL COMMENT 'CPU利用率',
  `dpcpuratiopeak` decimal(22,0) DEFAULT NULL COMMENT 'CPU利用率峰值',
  `dpcpuratioaverage` decimal(22,0) DEFAULT NULL COMMENT 'CPU利用率平均值',
  `dpcputemperature` decimal(22,0) DEFAULT NULL COMMENT 'CPU温度',
  `dpmemratio` decimal(22,0) DEFAULT NULL COMMENT '内存利用率',
  `dpmemratiopeak` decimal(22,0) DEFAULT NULL COMMENT '内存利用率峰值',
  `dpmemratioaverage` decimal(22,0) DEFAULT NULL COMMENT '内存利用率平均值',
  `dpmainboardtemperature` decimal(22,0) DEFAULT NULL COMMENT '主板温度',
  `dpsession` decimal(22,0) DEFAULT NULL COMMENT '会话个数',
  `dpcpuratio30s` decimal(22,0) DEFAULT NULL COMMENT '30秒内CPU利用率',
  `dpcpuratio5min` decimal(22,0) DEFAULT NULL COMMENT '300秒内CPU利用率',
  `detectioned_state` varchar(2) DEFAULT NULL,
  `seq_id` int(11) DEFAULT NULL COMMENT '物理位置节点',
  `data_check_time` datetime NOT NULL COMMENT '获取监测数据时间',
  `data_arrive_time` datetime DEFAULT NULL COMMENT '数据入库时间',
  `data_check_time_digital` decimal(22,0) DEFAULT NULL COMMENT '获取监测数据时间',
  `data_arrive_time_digital` decimal(22,0) DEFAULT NULL COMMENT '数据入库时间',
  `id` bigint(20) NOT NULL DEFAULT 0,
  `detection_set_info_id` int(11) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`id`,`data_check_time`),
  KEY `INDEX_DI_DSYSSTATUS_SET_ID` (`detection_set_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_ifxtable
-- ----------------------------
DROP TABLE IF EXISTS `di_ifxtable`;
CREATE TABLE `di_ifxtable` (
  `detection_info_id` int(11) NOT NULL,
  `ifname` varchar(25) DEFAULT NULL,
  `inmulticastpkts` decimal(22,0) DEFAULT NULL,
  `inbroadcastpkts` decimal(22,0) DEFAULT NULL,
  `outmulcastpkts` decimal(22,0) DEFAULT NULL,
  `outbrocastpkts` decimal(22,0) DEFAULT NULL,
  `ifhcinoctets` decimal(22,0) DEFAULT NULL,
  `hcinucastpkts` decimal(22,0) DEFAULT NULL,
  `hcimulcastpkts` decimal(22,0) DEFAULT NULL,
  `hcibrocastpkts` decimal(22,0) DEFAULT NULL,
  `hcoutoctets` decimal(22,0) DEFAULT NULL,
  `hcoucastpkts` decimal(22,0) DEFAULT NULL,
  `hcomulcastpkts` decimal(22,0) DEFAULT NULL,
  `hcobrocastpkts` decimal(22,0) DEFAULT NULL,
  `linkupdowntrape` decimal(22,0) DEFAULT NULL,
  `ifhighspeed` decimal(22,0) DEFAULT NULL,
  `promiscuousmode` decimal(22,0) DEFAULT NULL,
  `connectorpresen` decimal(22,0) DEFAULT NULL,
  `ifalias` varchar(50) DEFAULT NULL,
  `counterdisconti` varchar(100) DEFAULT NULL,
  `detectioned_state` varchar(2) DEFAULT NULL,
  `seq_id` decimal(22,0) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` decimal(22,0) DEFAULT NULL,
  `data_arrive_time_digital` decimal(22,0) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_set_info_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`data_check_time`),
  KEY `INDEX_DI_IFXTABLE_SET_ID` (`detection_set_info_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4268 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_propmstatus
-- ----------------------------
DROP TABLE IF EXISTS `di_propmstatus`;
CREATE TABLE `di_propmstatus` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_info_id` bigint(20) NOT NULL,
  `propmStatus` bigint(20) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` int(11) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(20) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` bigint(20) DEFAULT NULL,
  `data_arrive_time_digital` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`,`data_check_time`),
  KEY `DI_PROPMSTATUS_1` (`data_check_time`),
  KEY `DI_PROPMSTATUS_2` (`SEQ_ID`),
  KEY `DI_PROPMSTATUS_3` (`DETECTION_SET_INFO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1666 DEFAULT CHARSET=utf8
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_rule
-- ----------------------------
DROP TABLE IF EXISTS `di_rule`;
CREATE TABLE `di_rule` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_info_id` bigint(20) NOT NULL,
  `ServiceIndex` bigint(20) DEFAULT NULL,
  `ServiceCode` bigint(20) DEFAULT NULL,
  `ServiceDesc` varchar(32) DEFAULT NULL,
  `agedTime` bigint(20) DEFAULT NULL,
  `ClientNum` bigint(20) DEFAULT NULL,
  `RefluxPort` varchar(64) DEFAULT NULL,
  `RuleNumber` varchar(1024) DEFAULT NULL,
  `usedRuleNum` varchar(1024) DEFAULT NULL,
  `leftRuleNum` varchar(1024) DEFAULT NULL,
  `HitTotalNum` varchar(64) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` int(11) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(20) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` bigint(20) DEFAULT NULL,
  `data_arrive_time_digital` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`,`data_check_time`),
  KEY `DI_SUGON_RULE_1` (`data_check_time`),
  KEY `DI_SUGON_RULE_2` (`SEQ_ID`),
  KEY `DI_SUGON_RULE_3` (`DETECTION_SET_INFO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1277499 DEFAULT CHARSET=utf8
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_dklog
-- ----------------------------
DROP TABLE IF EXISTS `di_dklog`;
CREATE TABLE `di_dklog` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_info_id` bigint(20) NOT NULL,
  `logpath` varchar(256) DEFAULT NULL,
  `reptime` datetime DEFAULT NULL,
  `repcontent` varchar(256) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` int(11) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(20) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` bigint(20) DEFAULT NULL,
  `data_arrive_time_digital` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`,`data_check_time`),
  KEY `DI_DKLOG_1` (`data_check_time`),
  KEY `DI_DKLOG_2` (`SEQ_ID`),
  KEY `DI_DKLOG_3` (`DETECTION_SET_INFO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1649 DEFAULT CHARSET=utf8
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_sugon_board
-- ----------------------------
DROP TABLE IF EXISTS `di_sugon_board`;
CREATE TABLE `di_sugon_board` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `detection_info_id` bigint(20) NOT NULL,
  `boardSlotIndex` bigint(20) DEFAULT NULL,
  `boardType` varchar(16) DEFAULT NULL,
  `SeriesNumber` varchar(32) DEFAULT NULL,
  `boardWorkMode` bigint(20) DEFAULT NULL,
  `boardRunTimes` varchar(64) DEFAULT NULL,
  `slotIsMain` bigint(20) DEFAULT NULL,
  `Temperature` bigint(20) DEFAULT NULL,
  `CpuUtilization` bigint(20) DEFAULT NULL,
  `Memory` bigint(20) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` int(11) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(20) DEFAULT NULL,
  `data_check_time` datetime NOT NULL,
  `data_arrive_time` datetime DEFAULT NULL,
  `data_check_time_digital` bigint(20) DEFAULT NULL,
  `data_arrive_time_digital` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`,`data_check_time`),
  KEY `DI_SUGON_BOARD_1` (`data_check_time`),
  KEY `DI_SUGON_BOARD_2` (`SEQ_ID`),
  KEY `DI_SUGON_BOARD_3` (`DETECTION_SET_INFO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
 PARTITION BY RANGE (to_days(`data_check_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_switchport
-- ----------------------------
DROP TABLE IF EXISTS `di_switchport`;
CREATE TABLE `di_switchport` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `IFINDEX` bigint(22) DEFAULT NULL COMMENT '索引',
  `IFDESCR` text DEFAULT NULL COMMENT '描述',
  `IFTYPE` bigint(22) DEFAULT NULL COMMENT '端口类型',
  `IFMTU` bigint(22) DEFAULT NULL COMMENT 'ifMtu',
  `IFSPEED` bigint(22) DEFAULT NULL COMMENT '端口带宽',
  `IFPHYSADDRESS` text DEFAULT NULL COMMENT 'mac地址',
  `IFADMINSTATUS` bigint(22) DEFAULT NULL COMMENT '管理状态',
  `IFOPERSTATUS` bigint(22) DEFAULT NULL COMMENT '打开状态',
  `IFLASTCHANGE` varchar(50) DEFAULT '' COMMENT '状态变更时间',
  `IFINOCTETS` bigint(22) DEFAULT NULL COMMENT '接收的字节',
  `IFINUCASTPKTS` bigint(22) DEFAULT NULL COMMENT '被承认的单向传输数据包',
  `IFINNUCASTPKTS` bigint(22) DEFAULT NULL COMMENT '被承认的非单向传输数据包',
  `IFINDISCARDS` bigint(22) DEFAULT NULL COMMENT '入站被丢弃的数据包',
  `IFINERRORS` bigint(22) DEFAULT NULL COMMENT '入站错误数据包',
  `IFINUNKNOWNPROTOS` bigint(22) DEFAULT NULL COMMENT '入站不知名的数据包',
  `IFOUTOCTETS` bigint(22) DEFAULT NULL COMMENT '输出字节数',
  `IFOUTUCASTPKTS` bigint(22) DEFAULT NULL COMMENT '单向传输数据包',
  `IFOUTNUCASTPKTS` bigint(22) DEFAULT NULL COMMENT '非单向传输数据包',
  `IFOUTDISCARDS` bigint(22) DEFAULT NULL COMMENT '出站被丢弃的数据包',
  `IFOUTERRORS` bigint(22) DEFAULT NULL COMMENT '出站传输失败的数据包',
  `IFOUTQLEN` bigint(22) DEFAULT NULL COMMENT '输出信息包排列的长度（数据包内）',
  `IFSPECIFIC` text DEFAULT NULL COMMENT '管理信息库（MIB）对端口详细的说明',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理位置节点',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `INOCTETSSPEED` bigint(22) DEFAULT NULL COMMENT '输入速度',
  `INERRORSSCALE` bigint(22) DEFAULT NULL COMMENT '输入错包率',
  `OUTOCTETSSPEED` bigint(22) DEFAULT NULL COMMENT '输出速度',
  `OUTERRORSSCALE` bigint(22) DEFAULT NULL COMMENT '输出错包率',
  `IFINDISCARDSPERC` bigint(22) DEFAULT NULL COMMENT '输入丢包率',
  `IFOUTDISCARDSPERC` bigint(22) DEFAULT NULL COMMENT '输出丢包率',
  `INPKTSSPEED` bigint(22) DEFAULT NULL COMMENT '收包速率',
  `OUTPKTSSPEED` bigint(22) DEFAULT NULL COMMENT '发包速率',
  `IFINDISCARDS_VARY` bigint(22) DEFAULT NULL,
  `IFOUTDISCARDS_VARY` bigint(22) DEFAULT NULL,
  `IFINERRORS_VARY` bigint(22) DEFAULT NULL,
  `IFOUTERRORS_VARY` bigint(22) DEFAULT NULL,
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  `IFINOCTETS_T1` bigint(22) DEFAULT NULL COMMENT '接收的字节',
  `IFINUCASTPKTS_T1` bigint(22) DEFAULT NULL COMMENT '被承认的单向传输数据包',
  `IFINNUCASTPKTS_T1` bigint(22) DEFAULT NULL COMMENT '被承认的非单向传输数据包',
  `IFOUTOCTETS_T1` bigint(22) DEFAULT NULL COMMENT '输出字节数',
  `IFOUTUCASTPKTS_T1` bigint(22) DEFAULT NULL COMMENT '单向传输数据包',
  `IFOUTNUCASTPKTS_T1` bigint(22) DEFAULT NULL COMMENT '非单向传输数据包',
  `IFHIGHSPEED` bigint(22) DEFAULT NULL COMMENT '端口速率单位（Mbps）',
  `DATA_64_FLAG` bigint(22) DEFAULT NULL COMMENT '64位数据标识',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DI_SWITCHPORT_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `DI_SWITCHPORT_2` (`IFSPEED`) USING BTREE,
  KEY `DI_SWITCHPORT_3` (`IFADMINSTATUS`) USING BTREE,
  KEY `DI_SWITCHPORT_4` (`IFOUTOCTETS`) USING BTREE,
  KEY `INDEX_DISW_SEQ_ID` (`SEQ_ID`) USING BTREE,
  KEY `INDEX_DISW_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=305999 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_system
-- ----------------------------
DROP TABLE IF EXISTS `di_system`;
CREATE TABLE `di_system` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `SYSDESCR` varchar(400) DEFAULT '',
  `SYSOBJECTID` varchar(400) DEFAULT '',
  `SYSUPTIME` varchar(400) DEFAULT '',
  `SYSCONTACT` varchar(400) DEFAULT '',
  `SYSNAME` varchar(400) DEFAULT '',
  `SYSLOCATION` varchar(400) DEFAULT '',
  `SYSSERVICES` varchar(400) DEFAULT '',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL,
  `DATA_CHECK_TIME` datetime NOT NULL,
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL,
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DI_SYSTEM_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `INDEX_DI_SYSTEM_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7143 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_systeminfo
-- ----------------------------
DROP TABLE IF EXISTS `di_systeminfo`;
CREATE TABLE `di_systeminfo` (
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `HOST_NAME` varchar(200) DEFAULT '' COMMENT '主机名称',
  `OPERATE_SYSTEM` varchar(200) DEFAULT '' COMMENT '操作系统和发行版本',
  `CPU_CNT` bigint(22) DEFAULT NULL COMMENT 'CPU核数',
  `CPU_MHZ` bigint(22) DEFAULT NULL COMMENT '主频',
  `MEMORY_SIZE` bigint(22) DEFAULT NULL COMMENT '内存大小(单位：G)',
  `SWAP_SIZE` bigint(22) DEFAULT NULL COMMENT 'SWAP大小(单位\\: G)',
  `DISK_SIZE` bigint(22) DEFAULT NULL COMMENT '硬盘总大小(单位\\: G)',
  `NET_CNT` bigint(22) DEFAULT NULL COMMENT '逻辑网卡数量',
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL COMMENT '物理节点位置',
  `DATA_CHECK_TIME` datetime NOT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL COMMENT '数据入库时间',
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '获取监测数据时间',
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL COMMENT '数据入库时间',
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL COMMENT '监测设置id',
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `DI_SYSTEMINFO_1` (`DATA_CHECK_TIME`) USING BTREE,
  KEY `INDEX_DI_SYSTEMINFO_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3125 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_systeminfo_disk
-- ----------------------------
DROP TABLE IF EXISTS `di_systeminfo_disk`;
CREATE TABLE `di_systeminfo_disk` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `DISK_RANG` varchar(50) DEFAULT NULL,
  `DISK_SIZE` bigint(22) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL,
  `DATA_CHECK_TIME` datetime NOT NULL,
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL,
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `INDEX_DI_SYSDISK_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7745 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for di_systeminfo_net
-- ----------------------------
DROP TABLE IF EXISTS `di_systeminfo_net`;
CREATE TABLE `di_systeminfo_net` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DETECTION_INFO_ID` bigint(22) DEFAULT NULL,
  `NET_NAME` varchar(100) DEFAULT NULL,
  `NET_STATE` varchar(50) DEFAULT NULL,
  `NET_SPEED` bigint(20) DEFAULT NULL,
  `NET_IP` varchar(50) DEFAULT NULL,
  `NET_SUBMASK` varchar(50) DEFAULT NULL,
  `NET_GATEWAY` varchar(50) DEFAULT NULL,
  `NET_MAC` varchar(50) DEFAULT NULL,
  `DETECTIONED_STATE` varchar(2) DEFAULT NULL,
  `SEQ_ID` bigint(22) DEFAULT NULL,
  `DATA_CHECK_TIME` datetime NOT NULL,
  `DATA_ARRIVE_TIME` datetime DEFAULT NULL,
  `DATA_CHECK_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DATA_ARRIVE_TIME_DIGITAL` bigint(22) DEFAULT NULL,
  `DETECTION_SET_INFO_ID` bigint(22) DEFAULT NULL,
  PRIMARY KEY (`ID`,`DATA_CHECK_TIME`),
  KEY `INDEX_DI_SYSNET_SET_ID` (`DETECTION_SET_INFO_ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14539 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT
 PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);



-- ----------------------------
-- Table structure for email_table
-- ----------------------------
DROP TABLE IF EXISTS `email_table`;
CREATE TABLE `email_table` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `to_address` varchar(100) DEFAULT '' COMMENT '接收地址',
  `action_type` decimal(22,0) DEFAULT NULL COMMENT '事件类型 值域10监测恢复，11监测信息异常，13:监测结果超时，21主动告警恢复，20主动告警异常，31结果失败，32任务状态变更，40系统运行异常恢复，41系统运行异常',
  `content` varchar(2000) DEFAULT '' COMMENT '邮件内容',
  `send_flag` decimal(22,0) DEFAULT NULL COMMENT '0未发送 1已发送',
  `action_ip` varchar(100) DEFAULT '' COMMENT '地点',
  `action_date` datetime DEFAULT NULL COMMENT '触发时间，监测数据时间',
  `action_desc` varchar(255) DEFAULT '' COMMENT '事件标题（具体的监测、任务等名称标题）',
  `send_level` decimal(22,0) DEFAULT NULL COMMENT '值同 data_police_relation  POLICE_EMERGENT 的值',
  `create_time` datetime NOT NULL COMMENT '插入记录时间',
  PRIMARY KEY (`id`,`create_time`),
  KEY `FGDHDFGVBCG` (`action_date`) USING BTREE,
  KEY `FGHFGHFG` (`to_address`) USING BTREE,
  KEY `FGHFGHFGHFGGF` (`send_flag`) USING BTREE,
  KEY `FGHFGHFGHFGH` (`action_ip`) USING BTREE,
  KEY `FGHFGHFGHFH` (`action_type`) USING BTREE,
  KEY `SFGSFDFGDFG` (`action_desc`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='NMS产生的所有邮件信息'
 PARTITION BY RANGE (to_days(`create_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for event_record_library
-- ----------------------------
DROP TABLE IF EXISTS `event_record_library`;
CREATE TABLE `event_record_library` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `record_type` varchar(25) DEFAULT NULL,
  `record_content` longtext DEFAULT NULL,
  `seq_ids` int(11) DEFAULT NULL,
  `state` decimal(22,0) DEFAULT NULL,
  `record_command` varchar(125) DEFAULT NULL,
  `pid` decimal(22,0) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `table_id` decimal(22,0) DEFAULT NULL,
  `nmsserver_id` decimal(22,0) DEFAULT NULL,
  `sync_status` int(11) DEFAULT 0 COMMENT '是否为同步过来的数据 0不是 1 是',
  `old_id` bigint(20) DEFAULT NULL COMMENT '原库表id',
  `db_id` int(20) DEFAULT NULL COMMENT '原数据库id关联sync_db_info',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for flow_audit_rz
-- ----------------------------
DROP TABLE IF EXISTS `flow_audit_rz`;
CREATE TABLE `flow_audit_rz` (
  `seq` bigint(20) NOT NULL DEFAULT 0,
  `dip` varchar(18) NOT NULL,
  `dport` decimal(22,0) NOT NULL,
  `sip` varchar(18) NOT NULL,
  `sport` decimal(22,0) NOT NULL,
  `protocol` varchar(18) NOT NULL,
  `start_time` varchar(24) NOT NULL,
  `end_time` varchar(24) NOT NULL,
  `in_kb` decimal(22,0) NOT NULL,
  `out_kb` decimal(22,0) NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for gorup_system_table
-- ----------------------------
DROP TABLE IF EXISTS `gorup_system_table`;
CREATE TABLE `gorup_system_table` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `user_group_id` int(11) DEFAULT NULL COMMENT '用户组id',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统id',
  PRIMARY KEY (`id`),
  KEY `IDX_GROUPSYSTEMSYSTEMFKIDGORUP` (`system_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户组系统关系表';

-- ----------------------------
-- Table structure for img_url
-- ----------------------------
DROP TABLE IF EXISTS `img_url`;
CREATE TABLE `img_url` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `url` varchar(255) DEFAULT '' COMMENT '图片url路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='图片url';

-- ----------------------------
-- Table structure for loopmission_state_table
-- ----------------------------
DROP TABLE IF EXISTS `loopmission_state_table`;
CREATE TABLE `loopmission_state_table` (
  `cur_mission_id` bigint(20) NOT NULL COMMENT '当前周期id',
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id',
  `mission_state` decimal(22,0) DEFAULT NULL COMMENT '任务状态：不能为空，状态可选：1-任务已创建；2-任务已开始执行；3-任务已完成（包含部分节点失败情况）；4-任务未能执行',
  `start_time` datetime DEFAULT NULL COMMENT '周期开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '周期结束时间',
  `fail_desc` varchar(256) DEFAULT '' COMMENT '失败描述',
  PRIMARY KEY (`mission_id`,`cur_mission_id`),
  UNIQUE KEY `cur_mission_id` (`cur_mission_id`,`mission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for metadata
-- ----------------------------
DROP TABLE IF EXISTS `metadata`;
CREATE TABLE `metadata` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `check_type_id` decimal(22,0) DEFAULT NULL COMMENT '外键检测类别ID',
  `table_name` varchar(64) DEFAULT '' COMMENT '表名',
  `table_comments` varchar(100) DEFAULT '' COMMENT '表描述',
  `filed_name` varchar(64) DEFAULT '' COMMENT '字段名',
  `filed_comments` varchar(100) DEFAULT '' COMMENT '字段描述',
  `filed_type` varchar(20) DEFAULT '' COMMENT '字段类型',
  `create_date` datetime DEFAULT NULL COMMENT '创建日期',
  `create_person` decimal(22,0) DEFAULT NULL COMMENT '创建人',
  `state` char(1) DEFAULT '' COMMENT '是否启用标识0启用1停用',
  `update_date` datetime DEFAULT NULL COMMENT '停用时间',
  `update_person` decimal(22,0) DEFAULT NULL COMMENT '停用人',
  `chart_state` char(1) DEFAULT '' COMMENT '是否用于统计0启用1停用',
  `show_num` decimal(22,0) DEFAULT NULL COMMENT '在传输过程中的序号',
  `isnull` decimal(22,0) DEFAULT NULL COMMENT '是否为空',
  `oid` varchar(400) DEFAULT '' COMMENT 'oid',
  `sort_sign` decimal(22,0) DEFAULT 1 COMMENT '是否分类标识:0是；1否，公用统计图中的多线分类标识字段',
  `type_id` varchar(50) DEFAULT '' COMMENT '对应翻译字典，对部分标识字段的对应翻译字典',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='元数据定义，每个监测类别具体监测数据的定义';

-- ----------------------------
-- Table structure for mission_file_information
-- ----------------------------
DROP TABLE IF EXISTS `mission_file_information`;
CREATE TABLE `mission_file_information` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `mission_id` int(11) DEFAULT NULL COMMENT '任务id',
  `file_name` varchar(1024) DEFAULT '' COMMENT '文件名称',
  `dest_path` varchar(1024) DEFAULT '' COMMENT '源路径',
  `md5_value` varchar(128) DEFAULT '' COMMENT '文件校验值',
  `owner` varchar(25) DEFAULT '' COMMENT '推送文件的所有者（只针对Linux有效）',
  `permission` varchar(25) DEFAULT '' COMMENT '推送文件拥有的权限（只针对Linux有效）',
  `is_cover` varchar(1) DEFAULT '' COMMENT '覆盖标识（Y创建，N不创建 ，默认为N，忽略大小写）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务推送文件信息表';

-- ----------------------------
-- Table structure for mission_parameter_table1
-- ----------------------------
DROP TABLE IF EXISTS `mission_parameter_table1`;
CREATE TABLE `mission_parameter_table1` (
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id	主键',
  `mission_desc` varchar(256) DEFAULT '' COMMENT '任务描述	可以为空',
  `source_path` varchar(1024) DEFAULT '' COMMENT '文件源路径	不能为空，长度不能为0',
  `target_path` varchar(1024) DEFAULT '' COMMENT '文件目的路径	不能为空，长度不能为0',
  `check_value` varchar(128) DEFAULT '' COMMENT '文件校验值	不能为空，初步可以设定文件长度',
  `node_list_id` int(11) DEFAULT NULL COMMENT '节点组id	不能为空，外键',
  `os_limits` decimal(22,0) DEFAULT NULL COMMENT '-1系统类型无关（用于非系统升级标识）  0全系统 ， 1Windows系统， 2 Linux系统',
  `start_time` datetime DEFAULT NULL COMMENT '启动时间，或文件推送后任务重启时间',
  `version` decimal(22,0) DEFAULT NULL COMMENT '版本号',
  `is_create_cover` varchar(1) DEFAULT '' COMMENT '创建覆盖标识（Y创建，N不创建 ，默认为N，忽略大小写）',
  `command_para` longtext DEFAULT NULL COMMENT '文件推送参数',
  `node_groups_id` varchar(500) DEFAULT '' COMMENT '任务的有效节点组范围',
  `node_ips_id` varchar(500) DEFAULT '' COMMENT '设置的有效节点范围（存储节点id，用逗号连接）。如果有NODES_IP有值则不管节点组的有效范围；如果NODES_IP无值则使用节点组的范围；如果NODES_IP和NODE_GROUPS_ID均为空则有效范围是SYSTEM_ID系统内全部有效节点；如果三者均为空则有效范围为NMS系统内全部有效节点',
  PRIMARY KEY (`mission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务参数表1对应任务类型是文件推送的任务';

-- ----------------------------
-- Table structure for mission_parameter_table4
-- ----------------------------
DROP TABLE IF EXISTS `mission_parameter_table4`;
CREATE TABLE `mission_parameter_table4` (
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id	主键',
  `mission_desc` varchar(256) DEFAULT '' COMMENT '任务描述	可以为空',
  `command_type` decimal(22,0) DEFAULT NULL COMMENT '类型',
  `command_id` decimal(22,0) DEFAULT NULL COMMENT 'commond id',
  `command_para` longtext DEFAULT NULL COMMENT '文件推送参数',
  `filter_type` decimal(22,0) DEFAULT NULL COMMENT '过滤类型',
  `filter_keyword` varchar(1024) DEFAULT '' COMMENT '过滤关键词	支持与或表达式',
  `max_return` decimal(22,0) DEFAULT NULL COMMENT '返回结果最大长度	不能为空，缺省1024，返回结果的最大长度',
  `node_list_id` int(11) DEFAULT NULL COMMENT '节点组id	不能为空，外键',
  `version` decimal(22,0) DEFAULT NULL COMMENT '版本号',
  `node_groups_id` varchar(500) DEFAULT '' COMMENT '任务的有效节点组范围',
  `node_ips_id` varchar(500) DEFAULT '' COMMENT '设置的有效节点范围（存储节点id，用逗号连接）。如果有NODES_IP有值则不管节点组的有效范围；如果NODES_IP无值则使用节点组的范围；如果NODES_IP和NODE_GROUPS_ID均为空则有效范围是SYSTEM_ID系统内全部有效节点；如果三者均为空则有效范围为NMS系统内全部有效节点',
  `command_ename` varchar(50) DEFAULT '' COMMENT '命令名称，根据要求废弃command_id,使用命令名称作为命令唯一标识关联命令信息',
  PRIMARY KEY (`mission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务参数表';

-- ----------------------------
-- Table structure for mission_parameter_table6
-- ----------------------------
DROP TABLE IF EXISTS `mission_parameter_table6`;
CREATE TABLE `mission_parameter_table6` (
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id',
  `mission_desc` varchar(256) DEFAULT '' COMMENT '任务描述',
  `command_type` decimal(22,0) DEFAULT NULL COMMENT '类型',
  `command_id` int(11) DEFAULT NULL COMMENT 'command id',
  `command_para` longtext DEFAULT NULL COMMENT '文件推送参数',
  `filter_type` decimal(22,0) DEFAULT NULL COMMENT '过滤类型',
  `filter_keyword` varchar(1024) DEFAULT '' COMMENT '过滤关键词	支持与或表达式',
  `max_return` decimal(22,0) DEFAULT NULL COMMENT '返回结果最大长度	不能为空，缺省1024，返回结果的最大长度',
  `node_list_id` int(11) DEFAULT NULL COMMENT '节点组id	不能为空，外键',
  `source_path` varchar(1024) DEFAULT '' COMMENT '文件源路径	不能为空，长度不能为0',
  `target_path` varchar(1024) DEFAULT '' COMMENT '文件目的路径	不能为空，长度不能为0',
  `check_value` varchar(128) DEFAULT '' COMMENT '文件校验值	不能为空，初步可以设定文件长度',
  `start_time` datetime DEFAULT NULL COMMENT '启动时间，或文件推送后任务重启时间',
  `version` decimal(22,0) DEFAULT NULL COMMENT '版本号',
  `node_groups_id` varchar(500) DEFAULT '' COMMENT '任务的有效节点组范围',
  `node_ips_id` varchar(4000) DEFAULT '' COMMENT '设置的有效节点范围（存储节点id，用逗号连接）。如果有NODES_IP有值则不管节点组的有效范围；如果NODES_IP无值则使用节点组的范围；如果NODES_IP和NODE_GROUPS_ID均为空则有效范围是SYSTEM_ID系统内全部有效节点；如果三者均为空则有效范围为NMS系统内全部有效节点',
  `old_task_id` int(11) DEFAULT NULL COMMENT '再次执行任务ID',
  `command_ename` varchar(50) DEFAULT '' COMMENT '命令名称，根据要求废弃command_id,使用命令名称作为命令唯一标识关联命令信息',
  PRIMARY KEY (`mission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务参数表6升级任务参数信息表';

-- ----------------------------
-- Table structure for mission_result_table1
-- ----------------------------
DROP TABLE IF EXISTS `mission_result_table1`;
CREATE TABLE `mission_result_table1` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id	和下一项联合主键',
  `node_id` int(11) DEFAULT NULL COMMENT '节点id	节点id',
  `result` decimal(22,0) DEFAULT NULL COMMENT '执行失败，最终结果1;最终执行成功状态为0',
  `result_desc` longtext DEFAULT NULL COMMENT '失败原因	可以为空',
  `seq_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '物理位置唯一节点',
  PRIMARY KEY (`id`,`mission_id`,`seq_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for mission_result_table4
-- ----------------------------
DROP TABLE IF EXISTS `mission_result_table4`;
CREATE TABLE `mission_result_table4` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id',
  `node_id` int(11) DEFAULT NULL COMMENT '节点id',
  `result` decimal(22,0) DEFAULT NULL COMMENT '3任务信息下发中；40任务信息下发成功（信息有NMSAgent端提供），41任务信息下发失败（信息有NMSServer端提供）；以下结果由NMSAgent端提供：50停用进程成功，51停用进程失败；60备份失败，61备份成功；70覆盖目标目录成功，71覆盖目标目录失败；80启动成功，81启动失败；每个失败都表示本节点执行失败，最终结果1;最终执行成功状态为0',
  `result_desc` longtext DEFAULT NULL COMMENT '描述',
  `seq_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '物理位置唯一节点',
  `file_info` varchar(2048) DEFAULT '' COMMENT '上传文件存储字段（格式： 显示名称$@$实际名称;显示名称$@$实际名称',
  `result_detail` int(11) DEFAULT NULL COMMENT '任务结果失败的具体原因，目前只用于下发失败的情况(41)，主要用于下发失败后，再次初始化周期任务的结果时，默认结果为1（失败），具体结果为41（下发失败）',
  PRIMARY KEY (`id`,`mission_id`,`seq_id`)
) ENGINE=InnoDB AUTO_INCREMENT=591 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for mission_result_table6
-- ----------------------------
DROP TABLE IF EXISTS `mission_result_table6`;
CREATE TABLE `mission_result_table6` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id',
  `node_id` int(11) DEFAULT NULL COMMENT '节点id',
  `result` decimal(22,0) DEFAULT NULL COMMENT '3任务信息下发中；40任务信息下发成功（信息有NMSAgent端提供），41任务信息下发失败（信息有NMSServer端提供）；以下结果由NMSAgent端提供：50停用进程成功，51停用进程失败；60备份失败，61备份成功；70覆盖目标目录成功，71覆盖目标目录失败；80启动成功，81启动失败；每个失败都表示本节点执行失败，最终结果1;最终执行成功状态为0',
  `result_desc` longtext DEFAULT NULL COMMENT '描述',
  `seq_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '物理位置唯一节点',
  `file_info` varchar(2048) DEFAULT '' COMMENT '上传文件存储字段（格式： 显示名称$@$实际名称;显示名称$@$实际名称',
  PRIMARY KEY (`id`,`mission_id`,`seq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for mission_state_table
-- ----------------------------
DROP TABLE IF EXISTS `mission_state_table`;
CREATE TABLE `mission_state_table` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mission_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '任务id',
  `mission_name` varchar(64) DEFAULT '' COMMENT '任务名称',
  `mission_type` decimal(22,0) DEFAULT NULL COMMENT '任务类型	不能为空，类型可选[1、2、3、4、5]1-文件推送\r\n2-非流文本数据获取\r\n3-流文本数据获取\r\n4-命令执行\r\n5-shell注册',
  `mission_state` decimal(22,0) DEFAULT NULL COMMENT '任务状态  不能为空，状态可选[0、1、2、3、4、5]0-任务信息保存 1-任务已创建\r\n2-任务已开始执行\r\n3-周期任务已完成（包含部分节点失败情况），30、31、32非周期任务已完成（30-全部成功，31-全部失败，32-部分成功）\r\n4-任务未能执行\r\n5-定时任务已经被撤销',
  `view_level` decimal(22,0) DEFAULT NULL COMMENT '查看范围取值范围[1、3]\r\n1-发布人查看\r\n2-发布人所在组查看\r\n3-系统内全部人员可看',
  `user_id` int(11) DEFAULT NULL COMMENT '用户id',
  `group_id` int(11) DEFAULT NULL COMMENT '用户组id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始执行时间',
  `end_time` datetime DEFAULT NULL COMMENT '中止时间',
  `fail_desc` varchar(255) DEFAULT '' COMMENT '失败原因',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统id',
  `is_loop` decimal(22,0) DEFAULT NULL COMMENT '是否定时任务	不能为空：1是；0不是。默认值0',
  `loop_delay` decimal(22,0) DEFAULT NULL COMMENT '任务循环周期，单位为分钟	Loop_flag为1时不能为空',
  `contact_user_ids` varchar(512) DEFAULT '' COMMENT '联系人ID,逗号间隔',
  `failed_count` decimal(22,0) DEFAULT 0 COMMENT '失败数',
  `auto_desc` varchar(3200) DEFAULT NULL,
  `mission_state_desc` varchar(1000) DEFAULT '' COMMENT '任务结果状态的描述信息',
  `is_look` char(1) DEFAULT '' COMMENT '是否查看结果：0已查看  1未查看',
  `look_user_id` varchar(100) DEFAULT '' COMMENT '查看人ID',
  PRIMARY KEY (`id`,`mission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务状态表';

-- ----------------------------
-- Table structure for nms_error_code
-- ----------------------------
DROP TABLE IF EXISTS `nms_error_code`;
CREATE TABLE `nms_error_code` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `error_code` varchar(50) NOT NULL COMMENT '异常code;非空不重复',
  `error_name` varchar(100) NOT NULL COMMENT '异常名称:非空不重复',
  `error_des` varchar(200) DEFAULT '' COMMENT '异常描述',
  `error_level` decimal(22,0) NOT NULL DEFAULT 0 COMMENT '错误（告警）级别',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='NMS异常代码表';

-- ----------------------------
-- Table structure for nms_error_info
-- ----------------------------
DROP TABLE IF EXISTS `nms_error_info`;
CREATE TABLE `nms_error_info` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `error_code` varchar(50) DEFAULT '' COMMENT '异常code：非空',
  `error_time` datetime NOT NULL COMMENT '异常产生时间：非空',
  `errort_getip` varchar(20) DEFAULT '' COMMENT '异常信息提供IP：非空',
  `errort_ip` varchar(20) DEFAULT '' COMMENT '异常信息产生IP：非空',
  `error_state` decimal(22,0) DEFAULT NULL COMMENT '非空异常状态非空：0已解决；1未解决',
  `state_update_time` datetime DEFAULT NULL COMMENT '解决时间',
  `state_update_userid` decimal(22,0) DEFAULT NULL COMMENT '解决人',
  `error_des` varchar(200) DEFAULT '' COMMENT '异常描述信息',
  PRIMARY KEY (`id`,`error_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='异常信息表'
 PARTITION BY RANGE (to_days(`error_time`))
(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ENGINE = InnoDB);

-- ----------------------------
-- Table structure for nodegroup_arrow_position
-- ----------------------------
DROP TABLE IF EXISTS `nodegroup_arrow_position`;
CREATE TABLE `nodegroup_arrow_position` (
  `id` int(11) NOT NULL COMMENT '主键id',
  `system_id` int(11) NOT NULL COMMENT '业务系统id',
  `src_group_id` int(11) DEFAULT NULL COMMENT '箭头源节点组ID',
  `desc_group_id` int(11) DEFAULT NULL COMMENT '箭头目标节点组ID',
  `figure_x` decimal(22,0) NOT NULL COMMENT '图片X坐标',
  `figure_y` decimal(22,0) NOT NULL COMMENT '图片y坐标',
  `figure_width` decimal(22,0) NOT NULL COMMENT '宽',
  `figure_height` decimal(22,0) NOT NULL COMMENT '高',
  `figure_fill` varchar(100) NOT NULL COMMENT '填充色',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_userid` decimal(22,0) DEFAULT NULL COMMENT '创建人id',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  `last_update_userid` decimal(22,0) DEFAULT NULL COMMENT '最后修改人id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='拓扑图动态箭头位置预置数据表';

-- ----------------------------
-- Table structure for nodegroup_bgimg_position
-- ----------------------------
DROP TABLE IF EXISTS `nodegroup_bgimg_position`;
CREATE TABLE `nodegroup_bgimg_position` (
  `id` bigint(20) NOT NULL DEFAULT 0 COMMENT '主键id',
  `system_id` int(11) NOT NULL COMMENT '业务系统id',
  `group_id` int(11) NOT NULL COMMENT '节点组ID',
  `figure_x` decimal(22,0) NOT NULL COMMENT '图片x坐标',
  `figure_y` decimal(22,0) NOT NULL COMMENT '图片y坐标',
  `figure_width` decimal(22,0) NOT NULL COMMENT '宽',
  `figure_height` decimal(22,0) NOT NULL COMMENT '高',
  `figure_fill` varchar(100) NOT NULL COMMENT '填充色',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_userid` int(11) DEFAULT NULL COMMENT '创建人id',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后一次修改时间',
  `last_update_userid` decimal(22,0) DEFAULT NULL COMMENT '最后一次修改人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='逻辑拓扑图节点组背景图片位置表';

-- ----------------------------
-- Table structure for nodegroup_position
-- ----------------------------
DROP TABLE IF EXISTS `nodegroup_position`;
CREATE TABLE `nodegroup_position` (
  `id` bigint(20) NOT NULL DEFAULT 0 COMMENT '记录唯一标识',
  `system_id` int(11) NOT NULL COMMENT '业务系统id',
  `group_id` int(11) NOT NULL COMMENT '节点组id',
  `pgroup_id` int(11) NOT NULL COMMENT '父级组id',
  `show_level` decimal(22,0) NOT NULL COMMENT '显示层级',
  `show_index` decimal(22,0) DEFAULT NULL COMMENT '显示序号',
  `figure_type` varchar(64) NOT NULL COMMENT 'rect、circle、image等svg图形类型',
  `figure_x` decimal(22,0) DEFAULT NULL COMMENT 'x坐标',
  `figure_y` decimal(22,0) DEFAULT NULL COMMENT 'y坐标',
  `figure_width` decimal(22,0) DEFAULT NULL COMMENT '宽',
  `figure_height` decimal(22,0) DEFAULT NULL COMMENT '高',
  `figure_stroke` varchar(20) DEFAULT '' COMMENT '边缘填充色',
  `figure_stroke_width` decimal(22,0) DEFAULT NULL COMMENT '边宽',
  `figure_fill` varchar(100) DEFAULT '' COMMENT '填充色',
  `show_status` decimal(22,0) NOT NULL COMMENT '0：正常 1：异常，匹配不到的不显示状态',
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  `add_userid` decimal(22,0) DEFAULT NULL COMMENT '添加人',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  `last_update_userid` decimal(22,0) DEFAULT NULL COMMENT '最后修改人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='节点组位置信息表';

-- ----------------------------
-- Table structure for nodegroup_table
-- ----------------------------
DROP TABLE IF EXISTS `nodegroup_table`;
CREATE TABLE `nodegroup_table` (
  `group_id` int(11) NOT NULL DEFAULT 0 COMMENT '主键',
  `group_name` varchar(64) DEFAULT '' COMMENT '节点组名称',
  `view_level` decimal(22,0) DEFAULT NULL COMMENT '查看权限范围',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建人id',
  `create_usergroup_id` decimal(22,0) DEFAULT NULL COMMENT '创建人使用组id',
  `group_type` decimal(22,0) DEFAULT NULL COMMENT '组类型：1临时，0常态',
  `group_desc` varchar(256) DEFAULT '' COMMENT '组描述',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统id',
  `is_valid` decimal(22,0) DEFAULT NULL COMMENT '是否有效1有效，0无效',
  `group_createtime` datetime DEFAULT NULL COMMENT '创建时间',
  `parent_group_id` int(11) DEFAULT NULL COMMENT '父级组id',
  `leaf_group` decimal(22,0) DEFAULT NULL COMMENT '是否叶子节点组：1是，0否',
  `group_level` decimal(22,0) DEFAULT NULL COMMENT '组级别',
  `show_index` decimal(22,0) DEFAULT NULL COMMENT '显示序号',
  `parent_group_ids` varchar(512) DEFAULT '' COMMENT '父节点组成的字符创，原始节点为0',
  PRIMARY KEY (`group_id`),
  KEY `IDX_NODEGROUP_SYSTEMFKIDNODEGR` (`system_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='节点组信息表';

-- ----------------------------
-- Table structure for node_box_table
-- ----------------------------
DROP TABLE IF EXISTS `node_box_table`;
CREATE TABLE `node_box_table` (
  `box_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'id主键',
  `descinfo` varchar(200) DEFAULT '' COMMENT '机柜描述',
  `ispn` varchar(100) DEFAULT '' COMMENT '机柜编号',
  `box_u_type` decimal(22,0) DEFAULT NULL COMMENT '机柜U位',
  `room_ispn` varchar(200) DEFAULT '' COMMENT '机房编号',
  `room_row_position` decimal(22,0) DEFAULT NULL COMMENT '机房行号',
  `room_col_position` decimal(22,0) DEFAULT NULL COMMENT '机房列号',
  PRIMARY KEY (`box_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机柜信息表';

-- ----------------------------
-- Table structure for node_figure_info
-- ----------------------------
DROP TABLE IF EXISTS `node_figure_info`;
CREATE TABLE `node_figure_info` (
  `id` bigint(20) NOT NULL DEFAULT 0 COMMENT '主键',
  `pid` decimal(22,0) NOT NULL COMMENT '父id',
  `device_type_code` varchar(100) NOT NULL COMMENT '设备型号:作为设置数据检查参照',
  `seqid` int(11) NOT NULL COMMENT '节点物理标识',
  `show_level` decimal(22,0) NOT NULL COMMENT '图形级别:最多支持5级',
  `show_index` decimal(22,0) DEFAULT NULL COMMENT '级别下位置序号:注意从0还是从1开始',
  `name_flag` varchar(64) NOT NULL COMMENT '名称标识:例如：pos1_0,xgei_2/3,\r\nTen-GigabitEthernet14/0/1等',
  `port_oper_status` decimal(22,0) NOT NULL COMMENT '状态：1up；2down',
  `port_status` decimal(22,0) NOT NULL COMMENT 'Up端口的状态:0不正常；1正常',
  `figure_type` varchar(64) NOT NULL COMMENT 'rect、circle、image等svg图形类型',
  `figure_x` decimal(22,0) DEFAULT NULL COMMENT 'x坐标',
  `figure_y` decimal(22,0) DEFAULT NULL COMMENT 'y坐标',
  `figure_width` decimal(22,0) DEFAULT NULL COMMENT '宽',
  `figure_height` decimal(22,0) DEFAULT NULL COMMENT '高',
  `figure_stroke` varchar(20) DEFAULT '' COMMENT '边缘填充色',
  `figure_stroke_width` decimal(22,0) DEFAULT NULL COMMENT '边缘宽度',
  `figure_fill` varchar(100) DEFAULT '' COMMENT '填充色:图形为填充色；image为xlink:href内容',
  `data_check_time_digital` decimal(22,0) DEFAULT NULL COMMENT '监测时间id（new）作为svg文件名称',
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  `add_userid` decimal(22,0) DEFAULT NULL COMMENT '添加人',
  `last_update_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  `last_update_userid` decimal(22,0) DEFAULT NULL COMMENT '最后修改人',
  `figure_fill_model` varchar(100) DEFAULT '' COMMENT '做为FIGURE_FILL字段的模板',
  `is_leaf` decimal(22,0) DEFAULT NULL COMMENT '是否有链接，1：是，0：否（有的叶子节点没有链接，如电源、风扇）',
  `port_set_state` decimal(22,0) DEFAULT NULL COMMENT '端口设置状态：1up；2down',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='节点图形定义（根据设置生成）';

-- ----------------------------
-- Table structure for node_ip_table
-- ----------------------------
DROP TABLE IF EXISTS `node_ip_table`;
CREATE TABLE `node_ip_table` (
  `node_ip` varchar(64) DEFAULT '' COMMENT '节点ip',
  `node_id` int(11) DEFAULT NULL COMMENT '节点id',
  `node_type` decimal(22,0) DEFAULT NULL COMMENT '节点类型'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for node_lattice_record
-- ----------------------------
DROP TABLE IF EXISTS `node_lattice_record`;
CREATE TABLE `node_lattice_record` (
  `v_number` int(11) NOT NULL,
  `v_nodeSeqs` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for node_lattice_table
-- ----------------------------
DROP TABLE IF EXISTS `node_lattice_table`;
CREATE TABLE `node_lattice_table` (
  `id` bigint(20) NOT NULL DEFAULT 0 COMMENT '主键',
  `lattice_position` decimal(22,0) NOT NULL COMMENT '机柜中的U位位置从下到上',
  `node_box_id` int(11) NOT NULL COMMENT '机柜id',
  `node_seq` int(11) DEFAULT NULL COMMENT '物理节点seqid',
  `lottice_position_temp` decimal(22,0) DEFAULT NULL COMMENT '机柜中的U位位置从下到上bak',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机柜中个节点的格子';

-- ----------------------------
-- Table structure for node_position
-- ----------------------------
DROP TABLE IF EXISTS `node_position`;
CREATE TABLE `node_position` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `table_name` varchar(255) DEFAULT '' COMMENT '表名',
  `node_type` varchar(255) DEFAULT '' COMMENT '节点类型',
  `node_id` varchar(255) DEFAULT '' COMMENT '节点id',
  `position_x` decimal(22,0) DEFAULT NULL COMMENT '横坐标位置',
  `position_y` decimal(22,0) DEFAULT NULL COMMENT '纵坐标位置',
  `image_url` varchar(255) DEFAULT '' COMMENT '图片路径',
  `view_time_mark` datetime DEFAULT NULL COMMENT '创建展示的时间  通过时间间隔 ，借助CSS样式，用于区别新旧节点',
  `view_type` decimal(22,0) DEFAULT NULL COMMENT '展示类别（0:默认值，普通节点  1:图标集合，可双击展示子图  2:方块集合，其子节点均为方块展示）',
  `parent_id` int(11) DEFAULT NULL COMMENT '父级关联节点ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='拓扑位置关系表';

-- ----------------------------
-- Table structure for node_room_lattice_table
-- ----------------------------
DROP TABLE IF EXISTS `node_room_lattice_table`;
CREATE TABLE `node_room_lattice_table` (
  `id` bigint(20) NOT NULL DEFAULT 0 COMMENT '主键id',
  `lattice_row_position` decimal(22,0) NOT NULL COMMENT '机房中的行位置',
  `lattice_col_position` decimal(22,0) NOT NULL COMMENT '机房中的列位置',
  `room_id` int(11) NOT NULL COMMENT '机房id',
  `node_box_id` int(11) DEFAULT NULL COMMENT '机柜id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机房位置表';

-- ----------------------------
-- Table structure for node_room_table
-- ----------------------------
DROP TABLE IF EXISTS `node_room_table`;
CREATE TABLE `node_room_table` (
  `room_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'ID主键',
  `room_ispn` varchar(100) NOT NULL COMMENT '机房编号',
  `room_desc` varchar(200) DEFAULT '' COMMENT '机房描述',
  `room_rows` decimal(22,0) DEFAULT NULL COMMENT '机房行数',
  `room_cols` decimal(22,0) DEFAULT NULL COMMENT '机房列数',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建用户id',
  `create_datetime` datetime DEFAULT NULL COMMENT '创建时间',
  `update_user_id` int(11) DEFAULT NULL COMMENT '修改用户id',
  `update_datetime` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='机房表';

-- ----------------------------
-- Table structure for node_table
-- ----------------------------
DROP TABLE IF EXISTS `node_table`;
CREATE TABLE `node_table` (
  `node_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '主键',
  `node_ip` varchar(64) DEFAULT '' COMMENT 'ip',
  `node_type` decimal(22,0) DEFAULT NULL COMMENT '节点类型：服务器等',
  `node_name` varchar(64) DEFAULT '' COMMENT '节点名称',
  `node_desc` varchar(256) DEFAULT '' COMMENT '描述',
  `node_state` decimal(22,0) DEFAULT NULL COMMENT '节点状态：0，有效；1，无效''',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统id',
  `node_createtime` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建人id',
  `node_stoptime` datetime DEFAULT NULL COMMENT '停用时间',
  `stop_user_id` int(11) DEFAULT NULL COMMENT '停用人id',
  `is_temp` decimal(22,0) DEFAULT 0 COMMENT '临时节点标识默认0 临时节点，1为确认节点',
  `ipn` decimal(22,0) DEFAULT NULL COMMENT '整型IP值',
  `node_lattice_id` decimal(22,0) DEFAULT NULL COMMENT '格子id',
  `seq_id` int(11) DEFAULT NULL COMMENT '物理主机的唯一标识',
  `node_group_id` int(11) DEFAULT NULL COMMENT '节点组id',
  `node_u_type` decimal(22,0) DEFAULT NULL COMMENT '节点物理厚度（U位）',
  `brand_id` int(11) DEFAULT 0 COMMENT '品牌id',
  `snmp_version` varchar(256) DEFAULT '' COMMENT '节点支持的SNMP 的版本标准  version2c=1  version3=3',
  `node_system_type` decimal(22,0) DEFAULT NULL COMMENT '节点的操作系统类型：1 Linux，2   Windows， 3 Other',
  `node_mac` varchar(100) DEFAULT '' COMMENT '节点MAC地址',
  `node_ip_info` varchar(256) DEFAULT '' COMMENT '节点IP信息',
  `node_begin_utype` decimal(22,0) DEFAULT NULL COMMENT '节点起始U位',
  `node_box_ispn` varchar(100) DEFAULT '' COMMENT '机柜编号',
  `node_username` varchar(20) DEFAULT '' COMMENT '节点机用户名',
  `node_password` varchar(50) DEFAULT '' COMMENT '节点机密码',
  `network_element_type` decimal(22,0) DEFAULT NULL COMMENT '网元类型',
  `special_server_type` decimal(10,0) DEFAULT NULL COMMENT '特殊服务器类型',
  `sync_status` int(2) DEFAULT 0 COMMENT '是否为同步过来的数据',
  PRIMARY KEY (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for oid_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `oid_dictionary`;
CREATE TABLE `oid_dictionary` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `oid` varchar(200) NOT NULL,
  `dsc` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for operate_audit_rz
-- ----------------------------
DROP TABLE IF EXISTS `operate_audit_rz`;
CREATE TABLE `operate_audit_rz` (
  `seq` bigint(20) NOT NULL DEFAULT 0,
  `user_name` varchar(16) NOT NULL,
  `operate_desc` varchar(128) NOT NULL,
  `ins_time` datetime NOT NULL,
  `is_upload` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`seq`),
  KEY `IDX_INSERT_TIME` (`ins_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for option_table
-- ----------------------------
DROP TABLE IF EXISTS `option_table`;
CREATE TABLE `option_table` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `type_identity` varchar(50) NOT NULL,
  `type_code` varchar(64) DEFAULT '' COMMENT '字典项代码同一TYPE_ID下不重复',
  `type_value` varchar(64) DEFAULT '' COMMENT '字典项名称',
  `show_num` decimal(22,0) DEFAULT NULL COMMENT '字典项显示序号',
  `type_state` decimal(22,0) DEFAULT 0 COMMENT '字典项状态0启用；1停用',
  `delay_time` varchar(50) DEFAULT '' COMMENT '为0时，即时发，为-1时不发，其他数值为延时分钟数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for order_table
-- ----------------------------
DROP TABLE IF EXISTS `order_table`;
CREATE TABLE `order_table` (
  `command_id` bigint(20) NOT NULL DEFAULT 0,
  `command_name` varchar(64) DEFAULT '' COMMENT '命令名称',
  `command_desc` varchar(512) DEFAULT '' COMMENT '命令描述',
  `command_type` decimal(22,0) DEFAULT NULL COMMENT '命令类型',
  `command_flag` varchar(256) DEFAULT NULL,
  `shell_path` varchar(256) DEFAULT '' COMMENT '脚本路径',
  `shell_check` varchar(128) DEFAULT NULL,
  `is_valid` decimal(22,0) DEFAULT NULL,
  `command_model` varchar(2048) DEFAULT '' COMMENT '命令模板',
  `command_alias` varchar(32) DEFAULT '' COMMENT '别名',
  `command_modelnew` varchar(100) DEFAULT '' COMMENT '模板名称',
  PRIMARY KEY (`command_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='命令信息表';

-- ----------------------------
-- Table structure for plugin_info
-- ----------------------------
DROP TABLE IF EXISTS `plugin_info`;
CREATE TABLE `plugin_info` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL COMMENT '工具名称',
  `des` varchar(1000) DEFAULT '' COMMENT '工具描述',
  `file_name` varchar(1000) NOT NULL COMMENT '文件名',
  `creat_userid` int(11) DEFAULT NULL COMMENT '创建人',
  `creat_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_userid` int(11) DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='存放工具管理信息';

-- ----------------------------
-- Table structure for procedure_log
-- ----------------------------
DROP TABLE IF EXISTS `procedure_log`;
CREATE TABLE `procedure_log` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `pro_name` varchar(100) DEFAULT '' COMMENT '存储过程名称',
  `pro_sql` varchar(1000) DEFAULT '' COMMENT '存储过程语句',
  `er_info` varchar(1000) DEFAULT '' COMMENT '异常信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='存储过程异常日志信息';

-- ----------------------------
-- Table structure for proexecinfo
-- ----------------------------
DROP TABLE IF EXISTS `proexecinfo`;
CREATE TABLE `proexecinfo` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `proname` varchar(100) DEFAULT '' COMMENT '存储过程名称',
  `param` decimal(22,0) DEFAULT NULL COMMENT '执行参数值，在存储过程执行到每一行都更参数值',
  `prodesc` varchar(300) DEFAULT '' COMMENT '执行存储过程到每一行需要存储的关键字数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='存储过程执行信息表';

-- ----------------------------
-- Table structure for pro_exec_log
-- ----------------------------
DROP TABLE IF EXISTS `pro_exec_log`;
CREATE TABLE `pro_exec_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '日志记录时间，默认取数据库时间',
  `proname` varchar(100) DEFAULT '' COMMENT '存储过程名称',
  `sequence` varchar(100) DEFAULT '' COMMENT '步骤编号',
  `log_cont` varchar(1024) DEFAULT '' COMMENT '日志详细内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10984 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for server_ip_segment
-- ----------------------------
DROP TABLE IF EXISTS `server_ip_segment`;
CREATE TABLE `server_ip_segment` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `server_id` int(11) NOT NULL COMMENT 'Server_table Id',
  `start_ip` varchar(100) DEFAULT '' COMMENT '起始ip',
  `start_ipn` decimal(22,0) DEFAULT NULL COMMENT '起始ipn',
  `end_ip` varchar(100) DEFAULT '' COMMENT '结束ip',
  `end_ipn` decimal(22,0) DEFAULT NULL COMMENT '结束ipn',
  `segment_state` decimal(22,0) DEFAULT 0 COMMENT '范围状态标示（0:固定和默认值 1:临时 2:自定义  -1:无效）（预留值-1，用于优化业务）',
  `node_type` decimal(22,0) DEFAULT NULL COMMENT '节点类型（由节点表 服务器交换机等节点类型的对应值）',
  `node_count` decimal(22,0) DEFAULT NULL COMMENT '管理节点数（计算后更新，只作为展示使用）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='NMSDataController服务器IP段信息表';

-- ----------------------------
-- Table structure for server_table
-- ----------------------------
DROP TABLE IF EXISTS `server_table`;
CREATE TABLE `server_table` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `server_name` varchar(100) DEFAULT '' COMMENT 'NMSDataController名称',
  `server_state` decimal(22,0) DEFAULT NULL COMMENT 'server状态 0有效 1无效',
  `server_ip` varchar(100) DEFAULT '' COMMENT 'server_ip',
  `server_ipn` decimal(22,0) DEFAULT NULL COMMENT 'server_ipn',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `server_desc` varchar(500) DEFAULT '' COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='NMSDataController 服务器信息表';

-- ----------------------------
-- Table structure for set_det_data_con
-- ----------------------------
DROP TABLE IF EXISTS `set_det_data_con`;
CREATE TABLE `set_det_data_con` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_name` varchar(200) DEFAULT '' COMMENT '菜单名称，对应菜单名称修改时，可以修改，用于显示给用户',
  `police_level` varchar(200) DEFAULT '' COMMENT '告警级别：目前支持1-5级',
  `police_emergent` varchar(20) DEFAULT '' COMMENT '告警是否紧急 0：紧急  1：非紧急',
  `menu_code` varchar(100) DEFAULT '' COMMENT '菜单编号，不会改变',
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10024 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监测数据列表过滤条件的设置信息表';

-- ----------------------------
-- Table structure for sort_info
-- ----------------------------
DROP TABLE IF EXISTS `sort_info`;
CREATE TABLE `sort_info` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `sort_name` varchar(100) DEFAULT '' COMMENT '类别名称',
  `sort_desc` varchar(600) DEFAULT '' COMMENT '类别描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='监测名称定义表：如cpu用户使用率(%)、cpu系统使用率(%) 、硬盘使用率等';

-- ----------------------------
-- Table structure for sync_db_info
-- ----------------------------
DROP TABLE IF EXISTS `sync_db_info`;
CREATE TABLE `sync_db_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `ip` varchar(64) NOT NULL COMMENT '数据库ip',
  `port` int(11) NOT NULL COMMENT '端口号',
  `database_name` varchar(64) NOT NULL COMMENT '数据库名称',
  `user` varchar(64) DEFAULT NULL COMMENT '用户名',
  `password` varchar(64) DEFAULT NULL COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for system_company_config
-- ----------------------------
DROP TABLE IF EXISTS `system_company_config`;
CREATE TABLE `system_company_config` (
  `config_id` bigint(20) NOT NULL DEFAULT 0,
  `company_name` varchar(100) NOT NULL,
  `company_desc` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for system_gateway_config
-- ----------------------------
DROP TABLE IF EXISTS `system_gateway_config`;
CREATE TABLE `system_gateway_config` (
  `config_id` bigint(20) NOT NULL DEFAULT 0,
  `gateway_name` varchar(20) DEFAULT NULL,
  `gateway_ip` varchar(20) NOT NULL,
  `port` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for system_ip_config
-- ----------------------------
DROP TABLE IF EXISTS `system_ip_config`;
CREATE TABLE `system_ip_config` (
  `config_id` bigint(20) NOT NULL DEFAULT 0,
  `port` varchar(20) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `mac` varchar(20) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `ip_type` decimal(22,0) DEFAULT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for system_proxy_config
-- ----------------------------
DROP TABLE IF EXISTS `system_proxy_config`;
CREATE TABLE `system_proxy_config` (
  `config_id` bigint(20) NOT NULL DEFAULT 0,
  `proxy_ip` varchar(20) NOT NULL,
  `proxy_port` varchar(20) DEFAULT NULL,
  `proxy_password` varchar(20) DEFAULT NULL,
  `is_enabled` decimal(22,0) NOT NULL,
  `proxy_type` decimal(22,0) NOT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for system_route_config
-- ----------------------------
DROP TABLE IF EXISTS `system_route_config`;
CREATE TABLE `system_route_config` (
  `config_id` bigint(20) NOT NULL DEFAULT 0,
  `destination_ip` varchar(20) NOT NULL,
  `ip_mask` varchar(20) NOT NULL,
  `gateway` varchar(20) DEFAULT NULL,
  `interface` varchar(20) NOT NULL,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for system_table
-- ----------------------------
DROP TABLE IF EXISTS `system_table`;
CREATE TABLE `system_table` (
  `system_id` bigint(20) NOT NULL DEFAULT 0,
  `system_name` varchar(64) DEFAULT '' COMMENT '系统名称',
  `system_desc` varchar(256) DEFAULT '' COMMENT '系统描述',
  `system_state` varchar(1) DEFAULT '' COMMENT '系统信息状态 （0有效，1无效）',
  `system_createtime` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建人',
  `system_stoptime` datetime DEFAULT NULL COMMENT '停用时间',
  `stop_user_id` int(11) DEFAULT NULL COMMENT '停用人',
  `system_ip` varchar(100) DEFAULT '' COMMENT '系统webIP',
  `system_ipn` decimal(22,0) DEFAULT NULL COMMENT '系统webIPN',
  `system_port` decimal(22,0) DEFAULT NULL COMMENT '系统web端口',
  `system_start_state` decimal(22,0) DEFAULT NULL COMMENT '系统web启动状态（0启动，1未启动）',
  `is_master` decimal(22,0) DEFAULT NULL COMMENT '主控系统标识 （1主控系统  2子系统）',
  PRIMARY KEY (`system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统信息表（NMSWeb信息表）';

-- ----------------------------
-- Table structure for sys_data_dictionary_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_data_dictionary_item`;
CREATE TABLE `sys_data_dictionary_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(64) NOT NULL,
  `item_value` varchar(64) NOT NULL,
  `item_desc` varchar(256) DEFAULT NULL,
  `status` decimal(22,0) DEFAULT NULL,
  `type` decimal(22,0) DEFAULT NULL,
  `dic_id` int(11) NOT NULL,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for sys_data_dictionary_name
-- ----------------------------
DROP TABLE IF EXISTS `sys_data_dictionary_name`;
CREATE TABLE `sys_data_dictionary_name` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(64) NOT NULL,
  `mark` varchar(64) NOT NULL,
  `remark` varchar(256) DEFAULT NULL,
  `revision` varchar(1024) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `modify_time` datetime DEFAULT NULL,
  `valid` decimal(22,0) DEFAULT NULL,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for sys_sequence
-- ----------------------------
DROP TABLE IF EXISTS `sys_sequence`;
CREATE TABLE `sys_sequence` (
  `NAME` varchar(50) NOT NULL COMMENT '序号名称',
  `CURRENT_VALUE` bigint(21) NOT NULL DEFAULT 0 COMMENT '值',
  `INCREMENT` int(11) NOT NULL DEFAULT 1 COMMENT '每次递增数',
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for tabledboperationrpt
-- ----------------------------
DROP TABLE IF EXISTS `tabledboperationrpt`;
CREATE TABLE `tabledboperationrpt` (
  `logid` bigint(20) NOT NULL DEFAULT 0 COMMENT '用户id',
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `time` datetime DEFAULT NULL COMMENT '时间',
  `objtable` varchar(50) DEFAULT '' COMMENT '操作表名',
  `objid` decimal(22,0) DEFAULT NULL COMMENT '操作id',
  `action` varchar(50) DEFAULT '' COMMENT '请求路径',
  `sqlcondition` longtext DEFAULT NULL COMMENT '条件',
  PRIMARY KEY (`logid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for tabledepartment
-- ----------------------------
DROP TABLE IF EXISTS `tabledepartment`;
CREATE TABLE `tabledepartment` (
  `deptid` bigint(20) NOT NULL DEFAULT 0,
  `deptname` varchar(50) DEFAULT '' COMMENT '部门名称',
  `upperlayer` decimal(22,0) DEFAULT NULL COMMENT '是否为根',
  `deptstate` char(1) DEFAULT '' COMMENT '0:有效  1：无效',
  `pids` varchar(512) DEFAULT '' COMMENT '上级部门id组成的字符串',
  PRIMARY KEY (`deptid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for tableloginrpt
-- ----------------------------
DROP TABLE IF EXISTS `tableloginrpt`;
CREATE TABLE `tableloginrpt` (
  `username` varchar(50) DEFAULT '' COMMENT '用户名',
  `logid` bigint(20) NOT NULL DEFAULT 0 COMMENT '用户id',
  `ip` varchar(16) DEFAULT '' COMMENT '登录ip',
  `time` datetime DEFAULT NULL COMMENT '时间',
  `action` varchar(100) DEFAULT '' COMMENT '请求路径',
  `status` varchar(200) DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`logid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for tableuserdepartment
-- ----------------------------
DROP TABLE IF EXISTS `tableuserdepartment`;
CREATE TABLE `tableuserdepartment` (
  `deptid` int(11) DEFAULT NULL COMMENT '部门id',
  `userid` int(11) DEFAULT NULL COMMENT '用户id',
  `id` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='部门用户关系表';

-- ----------------------------
-- Table structure for table_event_log
-- ----------------------------
DROP TABLE IF EXISTS `table_event_log`;
CREATE TABLE `table_event_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键自增',
  `table_name` varchar(64) NOT NULL COMMENT '表名',
  `event` int(255) NOT NULL COMMENT '操作  1.insert 2.update 3 delete',
  `target_id` bigint(20) NOT NULL COMMENT '记录对应的id 一个主键时使用',
  `ids` varchar(255) DEFAULT NULL COMMENT '多个主键时使用，用;分割',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=279776 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for table_guide
-- ----------------------------
DROP TABLE IF EXISTS `table_guide`;
CREATE TABLE `table_guide` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `guide_id` int(11) NOT NULL COMMENT '向导id',
  `guide_name` varchar(20) DEFAULT '' COMMENT '向导名称',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='设置向导';

-- ----------------------------
-- Table structure for table_sync_info
-- ----------------------------
DROP TABLE IF EXISTS `table_sync_info`;
CREATE TABLE `table_sync_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键自增',
  `table_name` varchar(64) NOT NULL COMMENT '表名',
  `event` int(11) NOT NULL COMMENT '操作1:insert 2update 3delete 4 all（全量更新）',
  `id_name` varchar(64) DEFAULT NULL COMMENT '主键字段名 一个主键时使用',
  `id_names` varchar(128) DEFAULT NULL COMMENT '多个主键字段名  多个主键时使用，用;分割',
  `columns` varchar(255) DEFAULT NULL COMMENT '空则为全部字段 多个逗号分隔',
  `where` varchar(255) DEFAULT NULL COMMENT '过滤条件 用于同步时限制同步数据',
  `last_id` bigint(20) NOT NULL COMMENT '最后同步的id',
  `last_date` datetime NOT NULL COMMENT '最后同步的时间',
  `db_id` bigint(20) NOT NULL COMMENT '数据库id 关联 sync_db_info表',
  `mode` int(255) NOT NULL COMMENT '同步表主键生成方式，只对 insert 有效  mode=0：需要使用触发器更新 table_event_log 表，同步时需要关联table_event_log 表 mode=1：主键为自定义不重复主键  mode=2：主键自增 ',
  `batch_size` int(11) NOT NULL DEFAULT 500 COMMENT '批处理最大条数，默认：500',
  `interceptor` varchar(128) DEFAULT NULL COMMENT '入库拦截器配置的拦截器，可以实现在同步之前（before），之后（after）的其它操作',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1874 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for topo_con_info
-- ----------------------------
DROP TABLE IF EXISTS `topo_con_info`;
CREATE TABLE `topo_con_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `topo_id` int(11) NOT NULL COMMENT 'TOPO图ID 与TOPO_INFO关联',
  `x` int(11) NOT NULL COMMENT 'x轴坐标',
  `y` int(11) NOT NULL COMMENT 'y轴坐标',
  `width` int(11) NOT NULL COMMENT '图片宽度',
  `height` int(11) NOT NULL COMMENT '图片高度',
  `create_time` date NOT NULL COMMENT '创建时间',
  `create_user` int(11) NOT NULL COMMENT '创建人',
  `update_time` date NOT NULL COMMENT '更新时间',
  `update_user` int(11) NOT NULL COMMENT '修改人',
  `class` varchar(64) DEFAULT NULL COMMENT '样式',
  `text` varchar(64) DEFAULT NULL COMMENT 'NODE提示文本信息',
  `flag` int(11) NOT NULL DEFAULT 1 COMMENT '是否有效 0：无效，1：有效，默认：1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for topo_img
-- ----------------------------
DROP TABLE IF EXISTS `topo_img`;
CREATE TABLE `topo_img` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL COMMENT '文件名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for topo_info
-- ----------------------------
DROP TABLE IF EXISTS `topo_info`;
CREATE TABLE `topo_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) NOT NULL COMMENT '拓扑图名称',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统ID',
  `width` int(11) NOT NULL COMMENT '图片宽度',
  `height` int(11) NOT NULL COMMENT '图片高度',
  `class` varchar(255) NOT NULL COMMENT '样式',
  `create_time` date NOT NULL COMMENT '创建时间',
  `create_user` int(11) NOT NULL COMMENT '创建人',
  `update_time` date NOT NULL COMMENT '修改时间',
  `update_user` int(11) NOT NULL COMMENT '修改人',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `threshold` int(11) DEFAULT NULL COMMENT '域值 主要对节点组有效',
  `flag` int(11) NOT NULL DEFAULT 1 COMMENT '0：无效，1：有效，默认：1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for topo_line_info
-- ----------------------------
DROP TABLE IF EXISTS `topo_line_info`;
CREATE TABLE `topo_line_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `src` int(11) DEFAULT NULL COMMENT '线起点 TOPO_NODE_INFO 表的ID',
  `dest` int(11) DEFAULT NULL COMMENT '线终点 TOPO_NODE_INFO 表的ID',
  `class` varchar(256) DEFAULT NULL COMMENT '线的样式 1：节点组，2：节点，3：其它',
  `text` varchar(64) DEFAULT NULL COMMENT '线条文本内容',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  `create_user` int(11) DEFAULT NULL COMMENT '创建人',
  `update_time` date DEFAULT NULL COMMENT '更新时间',
  `update_user` int(11) DEFAULT NULL COMMENT '修改人',
  `topo_id` int(11) DEFAULT NULL COMMENT 'TOPO图ID 与TOPO_INFO关联',
  `flag` int(11) DEFAULT 1 COMMENT '是否有效 0：无效，1：有效，默认：1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=438 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for topo_node_info
-- ----------------------------
DROP TABLE IF EXISTS `topo_node_info`;
CREATE TABLE `topo_node_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `img_id` int(11) DEFAULT NULL COMMENT '图片id 与TOPO_IMG表ID关联',
  `topo_id` int(11) DEFAULT NULL COMMENT 'topo图ID 与TOPO_INFO关联',
  `type` int(11) DEFAULT NULL COMMENT 'NODE类型 1：节点组，2：节点，3：其它 4:topo',
  `type_id` int(11) DEFAULT NULL COMMENT 'NODE对应的节点组或节点ID 当：TYPE = 1时，为节点组ID，TYPE = 2时，为节点ID，TYPE =3 时，无意义 type=4时 topo',
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL COMMENT '图片宽度',
  `height` int(11) DEFAULT NULL COMMENT '图片高度',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  `create_user` int(11) DEFAULT NULL COMMENT '创建人',
  `update_time` date DEFAULT NULL COMMENT '更新时间',
  `update_user` int(11) DEFAULT NULL COMMENT '修改人',
  `text` varchar(64) DEFAULT NULL COMMENT 'NODE提示文本信息',
  `con_id` int(11) DEFAULT NULL COMMENT '容器ID 关联TOPO_CON_INFO 的ID',
  `class` varchar(255) DEFAULT NULL COMMENT '样式',
  `threshold_value` double(11,0) DEFAULT 80 COMMENT '阀值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for trouble_state
-- ----------------------------
DROP TABLE IF EXISTS `trouble_state`;
CREATE TABLE `trouble_state` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `trouble_code` decimal(22,0) NOT NULL COMMENT '故障代码',
  `trouble_info` varchar(200) NOT NULL COMMENT '故障名称',
  `trouble_descr` varchar(1000) DEFAULT '' COMMENT '故障描述说明信息',
  `system_id` int(11) DEFAULT NULL COMMENT '业务系统id',
  `create_id` int(11) DEFAULT NULL COMMENT '创建人id',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `last_update_id` int(11) DEFAULT NULL COMMENT '修改人id',
  `last_update_date` datetime DEFAULT NULL COMMENT '修改时间',
  `state` char(1) DEFAULT '' COMMENT '状态 0: 有效 1:无效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='故障库,故障代码在同一个业务系统内不重复';

-- ----------------------------
-- Table structure for type_table
-- ----------------------------
DROP TABLE IF EXISTS `type_table`;
CREATE TABLE `type_table` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `show_num` decimal(22,0) DEFAULT 0 COMMENT '显示序号',
  `type_state` decimal(22,0) NOT NULL DEFAULT 0 COMMENT '状态0启用；1停用',
  `type_desc` varchar(200) DEFAULT '' COMMENT '描述',
  `type_name` varchar(50) NOT NULL COMMENT '字典类型名称，不为空不重复',
  `type_identity` varchar(50) NOT NULL COMMENT '字典标识，不为空不重复',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='字典类型定义表：定义字典大类型';

-- ----------------------------
-- Table structure for update_model_rz
-- ----------------------------
DROP TABLE IF EXISTS `update_model_rz`;
CREATE TABLE `update_model_rz` (
  `update_id` bigint(20) NOT NULL DEFAULT 0,
  `model_id` int(11) NOT NULL,
  `model_name` varchar(64) NOT NULL,
  `model_version` varchar(16) NOT NULL,
  `is_valid` decimal(22,0) NOT NULL,
  `ins_time` datetime NOT NULL,
  PRIMARY KEY (`update_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for upload_file_rz
-- ----------------------------
DROP TABLE IF EXISTS `upload_file_rz`;
CREATE TABLE `upload_file_rz` (
  `unique_seq` bigint(20) NOT NULL DEFAULT 0,
  `file_type` decimal(22,0) NOT NULL,
  `file_path` varchar(128) NOT NULL,
  `gen_time` datetime NOT NULL,
  PRIMARY KEY (`unique_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for xt_js_jbxx
-- ----------------------------
DROP TABLE IF EXISTS `xt_js_jbxx`;
CREATE TABLE `xt_js_jbxx` (
  `jsmc` varchar(50) DEFAULT '' COMMENT '角色名称',
  `jsbh` bigint(20) NOT NULL DEFAULT 0 COMMENT '角色编号',
  `zxbz` varchar(1) DEFAULT '' COMMENT '是否有效，0：有效，1：无效',
  `jsms` varchar(200) DEFAULT '' COMMENT '角色描述',
  `ctime` datetime DEFAULT NULL COMMENT '创建时间',
  `type` decimal(22,0) DEFAULT NULL COMMENT '1：用户组，null：角色',
  PRIMARY KEY (`jsbh`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for xt_js_mk_index
-- ----------------------------
DROP TABLE IF EXISTS `xt_js_mk_index`;
CREATE TABLE `xt_js_mk_index` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `mkbh` decimal(22,0) DEFAULT NULL COMMENT '模块编号',
  `jsbh` varchar(50) DEFAULT '' COMMENT '角色编号',
  `ctime` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for xt_mk_jbxx
-- ----------------------------
DROP TABLE IF EXISTS `xt_mk_jbxx`;
CREATE TABLE `xt_mk_jbxx` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `pid` decimal(22,0) DEFAULT NULL COMMENT '父级id',
  `mkbh` varchar(50) DEFAULT '' COMMENT '模块编号',
  `mkmc` varchar(50) DEFAULT '' COMMENT '模块名称',
  `mkms` varchar(200) DEFAULT '' COMMENT '模块描述',
  `mkurl` varchar(200) DEFAULT '' COMMENT '模块url',
  `mktb` varchar(200) DEFAULT NULL,
  `zxbz` varchar(1) DEFAULT NULL,
  `ctime` datetime DEFAULT NULL COMMENT '创建时间',
  `iconimage` varchar(200) DEFAULT '' COMMENT '头像图标',
  `handler` varchar(200) DEFAULT '' COMMENT '操作',
  `mktype` decimal(22,0) DEFAULT NULL COMMENT '模块类型',
  `showlevel` decimal(22,0) DEFAULT NULL COMMENT '菜单级别',
  `showorder` decimal(22,0) DEFAULT NULL COMMENT '显示序号',
  `showarea` decimal(22,0) DEFAULT NULL COMMENT '0:主控和子控系统全显示；1:主控系统显示；2：子控系统显示',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for xt_yh_jbxx
-- ----------------------------
DROP TABLE IF EXISTS `xt_yh_jbxx`;
CREATE TABLE `xt_yh_jbxx` (
  `yhbh` varchar(50) DEFAULT '' COMMENT '用户编号',
  `yhmm` varchar(50) DEFAULT '' COMMENT '用户密码加密',
  `yhmc` varchar(50) DEFAULT '' COMMENT '用户名称',
  `gcdbh` varchar(50) DEFAULT NULL,
  `yhbbh` varchar(50) DEFAULT NULL,
  `dh` varchar(50) DEFAULT NULL,
  `fjhm` varchar(50) DEFAULT NULL,
  `isbz` varchar(1) DEFAULT NULL,
  `zxbz` varchar(1) DEFAULT NULL,
  `ctime` datetime DEFAULT NULL COMMENT '创建时间',
  `yhid` bigint(20) NOT NULL DEFAULT 0 COMMENT '用户id',
  `rigthmenuitems` varchar(200) DEFAULT NULL,
  `bgcolor` varchar(50) DEFAULT '' COMMENT '背景颜色',
  `email` varchar(256) DEFAULT '' COMMENT '邮箱',
  `pwdstate` char(1) DEFAULT '0' COMMENT '密码状态:0密码初始状态不可用;1密码已修改可用',
  `is_receiveemail` varchar(2) DEFAULT '' COMMENT '为0时，接收邮件，为1时不接收',
  `language` varchar(10) DEFAULT NULL COMMENT '语言类型，例：en_US,zh_CN,用于邮件发送，登录选择用户默认语言',
  PRIMARY KEY (`yhid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for xt_yh_js_index
-- ----------------------------
DROP TABLE IF EXISTS `xt_yh_js_index`;
CREATE TABLE `xt_yh_js_index` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `yhbh` varchar(50) DEFAULT '' COMMENT '用户编号',
  `jsbh` varchar(50) DEFAULT '' COMMENT '角色编号',
  `ctime` datetime DEFAULT NULL COMMENT '创建时间',
  `type` decimal(22,0) DEFAULT NULL COMMENT '类型',
  `yhid` decimal(22,0) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- View structure for pro_deltabspace_temp
-- ----------------------------
DROP VIEW IF EXISTS `pro_deltabspace_temp`;
CREATE ALGORITHM=UNDEFINED DEFINER=`nms`@`%` SQL SECURITY DEFINER VIEW `pro_deltabspace_temp` AS select `t`.`TABLE_NAME` AS `TABLE_NAME`,`t`.`PARTITION_NAME` AS `PARTITION_NAME` from `information_schema`.`partitions` `t` where `t`.`TABLE_SCHEMA` = 'nms' and `t`.`PARTITION_NAME` like 'NMS_PARTITION_%' and `t`.`PARTITION_DESCRIPTION` < 737368 ;

-- ----------------------------
-- View structure for v_detection_set_info
-- ----------------------------
DROP VIEW IF EXISTS `v_detection_set_info`;
CREATE ALGORITHM=UNDEFINED DEFINER=`nms`@`%` SQL SECURITY DEFINER VIEW `v_detection_set_info` AS select `dsi`.`ID` AS `ID`,`dsi`.`NODE_IP` AS `NODE_IP`,`dsi`.`CHECK_TYPE_ID` AS `CHECK_TYPE_ID`,`dsi`.`CHECK_GAP` AS `CHECK_GAP`,`dsi`.`CHECK_WAY` AS `CHECK_WAY`,`dsi`.`CHECK_OUT_TIME` AS `CHECK_OUT_TIME`,`dsi`.`CHECK_MAX_TIMES` AS `CHECK_MAX_TIMES`,`dsi`.`PROCESS_IDEN` AS `PROCESS_IDEN`,`dsi`.`DETECTION_SET_STATE` AS `DETECTION_SET_STATE`,`dsi`.`PROCESS_FILE` AS `PROCESS_FILE`,`dsi`.`PROCESS_PATH` AS `PROCESS_PATH`,`dsi`.`OID` AS `OID`,`dsi`.`IS_CONTROL_START` AS `IS_CONTROL_START`,`dsi`.`IS_ISSUE_FILE` AS `IS_ISSUE_FILE`,`dsi`.`IS_ISSUED` AS `IS_ISSUED`,`dsi`.`CONTROL_START_TIME` AS `CONTROL_START_TIME`,`dsi`.`UPLOAD_GAP` AS `UPLOAD_GAP`,`dsi`.`IS_ISSUE` AS `IS_ISSUE`,`dsi`.`PLAN_CHECK_TIME` AS `PLAN_CHECK_TIME`,`dsi`.`GROUP_ID` AS `GROUP_ID`,`dsi`.`VIEW_LEVEL` AS `VIEW_LEVEL`,`dsi`.`CONTACT_USER_IDS` AS `CONTACT_USER_IDS`,`dsi`.`CREATE_USER_ID` AS `CREATE_USER_ID`,`dsi`.`CREATE_USERGROUP_ID` AS `CREATE_USERGROUP_ID`,`dsi`.`SYSTEM_ID` AS `SYSTEM_ID`,`dsi`.`NODE_GROUPS_ID` AS `NODE_GROUPS_ID`,`dsi`.`NODE_IPS_ID` AS `NODE_IPS_ID`,`dsi`.`PROCESS_SEARCH_KEYCODE` AS `process_search_keycode`,`ngt`.`group_id` AS `node_group_id`,`ngt`.`is_valid` AS `is_valid`,`nt`.`node_id` AS `node_id`,`nt`.`node_state` AS `node_state`,`nt`.`seq_id` AS `seq_id` from ((`detection_set_info` `dsi` left join `nodegroup_table` `ngt` on(concat(',',`dsi`.`NODE_GROUPS_ID`,',') like concat('%,',`ngt`.`group_id`,',%'))) left join `node_table` `nt` on(concat(',',`dsi`.`NODE_IPS_ID`,',') like concat('%,',`nt`.`node_id`,',%') and `nt`.`node_group_id` = `ngt`.`group_id`)) ;

-- ----------------------------
-- View structure for v_mission_node_group_1
-- ----------------------------
DROP VIEW IF EXISTS `v_mission_node_group_1`;
CREATE ALGORITHM=UNDEFINED DEFINER=`nms`@`%` SQL SECURITY DEFINER VIEW `v_mission_node_group_1` AS select `mpt1`.`mission_id` AS `mission_id`,`ngt`.`group_id` AS `node_group_id`,`ngt`.`is_valid` AS `is_valid` from (`mission_parameter_table1` `mpt1` left join `nodegroup_table` `ngt` on(concat(',',`mpt1`.`node_groups_id`,',') like concat('%,',`ngt`.`group_id`,',%'))) ;

-- ----------------------------
-- View structure for v_mission_node_group_4
-- ----------------------------
DROP VIEW IF EXISTS `v_mission_node_group_4`;
CREATE ALGORITHM=UNDEFINED DEFINER=`nms`@`%` SQL SECURITY DEFINER VIEW `v_mission_node_group_4` AS select `mpt4`.`mission_id` AS `mission_id`,`ngt`.`group_id` AS `node_group_id`,`ngt`.`is_valid` AS `is_valid` from (`mission_parameter_table4` `mpt4` left join `nodegroup_table` `ngt` on(concat(',',`mpt4`.`node_groups_id`,',') like concat('%,',`ngt`.`group_id`,',%'))) ;

-- ----------------------------
-- View structure for v_mission_node_group_6
-- ----------------------------
DROP VIEW IF EXISTS `v_mission_node_group_6`;
CREATE ALGORITHM=UNDEFINED DEFINER=`nms`@`%` SQL SECURITY DEFINER VIEW `v_mission_node_group_6` AS select `mpt6`.`mission_id` AS `mission_id`,`ngt`.`group_id` AS `node_group_id`,`ngt`.`is_valid` AS `is_valid` from (`mission_parameter_table6` `mpt6` left join `nodegroup_table` `ngt` on(concat(',',`mpt6`.`node_groups_id`,',') like concat('%,',`ngt`.`group_id`,',%'))) ;

-- ----------------------------
-- View structure for v_node_table
-- ----------------------------
DROP VIEW IF EXISTS `v_node_table`;
CREATE ALGORITHM=UNDEFINED DEFINER=`nms`@`%` SQL SECURITY DEFINER VIEW `v_node_table` AS select distinct `node_table`.`node_ip` AS `node_ip`,`node_table`.`seq_id` AS `seq_id` from `node_table` ;

-- ----------------------------
-- Procedure structure for DELETE_DETECT
-- ----------------------------
DROP PROCEDURE IF EXISTS `DELETE_DETECT`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `DELETE_DETECT`()
    COMMENT '  删除监测时间大于7天的监测数据'
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE not_exist_flag INT DEFAULT 0;
	DECLARE v_sql varchar(500);
	DECLARE table_name VARCHAR(64);
	DECLARE cur_table_name CURSOR FOR SELECT DISTINCT t.table_name FROM check_type_info t WHERE 1 = 1 AND t.crete_state = 0 AND t.TABLE_NAME IS NOT NULL;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	DECLARE CONTINUE HANDLER FOR 1146 SET not_exist_flag = 1;
	OPEN cur_table_name;
	REPEAT
		FETCH cur_table_name INTO table_name;
		SET not_exist_flag = 0;
		IF NOT done THEN
				set v_sql= concat('DELETE c.*, t.* FROM ',table_name ,' c,detection_info t WHERE c.DETECTION_INFO_ID = t.ID AND DATEDIFF(SYSDATE(),t.DATA_CHECK_TIME)>7');
				set @v_sql=v_sql;
				prepare stmt from @v_sql;
				IF NOT not_exist_flag THEN
					EXECUTE stmt;
					deallocate prepare stmt;
				END IF;
		END IF;
	UNTIL done END REPEAT;
	CLOSE cur_table_name;
	DELETE t.* FROM DETECTION_INFO t where DATEDIFF(SYSDATE(),t.DATA_CHECK_TIME)>7;
	COMMIT;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_add_part_one_day
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_add_part_one_day`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_add_part_one_day`(v_table_name   VARCHAR(50),v_par_sequence   VARCHAR(50))
    DETERMINISTIC
BEGIN
   declare c_table_name_prefix        VARCHAR(100) ; 
   DECLARE c_log_table_name              VARCHAR(100) ; 
   DECLARE c_cur_pro_name                VARCHAR(100) ; 
   DECLARE v_log_table_sql               VARCHAR(2000);
   DECLARE v_last_tablespace_name_sql    VARCHAR(2000);
   DECLARE v_last_tablespace_name        VARCHAR(200);
   DECLARE v_tablespace_prefix_length    int;
   DECLARE  v_last_tablespace_name_date  int; 
   DECLARE v_next_tablespace_name_date   int; 
   DECLARE v_create_tablespace_sql       VARCHAR(2000); 
   DECLARE v_partition_time_date         int; 
   DECLARE v_add_partition_sql           VARCHAR(2000); 
   DECLARE v_sub_table_name              VARCHAR(200);
   DECLARE v_cur_year                    VARCHAR(4);
   DECLARE v_cur_week                    VARCHAR(4);
   
   set c_cur_pro_name :='pro_add_part_one_day';
   set c_table_name_prefix :='DI_';
   set c_log_table_name:='PRO_EXEC_LOG';
   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''',v_par_sequence,'1'',''1.判断',v_table_name,'表名长度是否大于21，如果大于，则从后往前截取21个字符 begin'')');
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
    
    set v_sub_table_name := v_table_name;
    if length(v_table_name)>21 then
       set v_sub_table_name := substring(v_table_name,-21);
    end if;
    set @v_log_table_sql :=concat('INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''',v_par_sequence,'2'',''2.截取前表名：',v_table_name,',截取后表名：',v_sub_table_name,' end'')');
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
    
    set @v_log_table_sql :=  concat('INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''',v_par_sequence,'3'',''3.获取',v_table_name,'表最近创建的表空间名 begin'')');
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
  
    set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''',v_par_sequence,'13'',''13.',v_table_name,'表 获取下一天时间分区对应的时间 begin'')');
    PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
    
   
   SET @v_next_tablespace_name_date :=  DATE_FORMAT(DATE_ADD(NOW(),INTERVAL 1 DAY),'%y%m%d');
   SET @v_partition_time_date:=  DATE_FORMAT(DATE_ADD(NOW(),INTERVAL 2 DAY),'%y%m%d');
   set  @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''',v_par_sequence,'14'',''14.',v_table_name,'表 获取下一天时间分区对应的时间 end'')');
  
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
   
   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''',v_par_sequence,'15'',''15.把表分区增加到',v_table_name,'表 begin'')');
    
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
    
     SET @v_add_partition_sql := CONCAT('ALTER TABLE ',v_table_name,' ADD PARTITION (PARTITION ',v_sub_table_name,'_' , @v_next_tablespace_name_date , ' VALUES LESS THAN ' , '(TO_DAYS(''',@v_partition_time_date,''')));') ;
 
  
	PREPARE  execs FROM @v_add_partition_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
    set @v_log_table_sql :=  'INSERT INTO '||c_log_table_name||'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,'''||c_cur_pro_name||''','''||v_par_sequence||'16'',''16.把表分区'||v_sub_table_name||'_' ||v_next_tablespace_name_date||'增加到'||v_table_name||'表 end'')';
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
 
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_createIndex
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_createIndex`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_createIndex`(tabName  VARCHAR(200),fileds  VARCHAR(200))
    DETERMINISTIC
BEGIN
	DECLARE c_log_table_name               VARCHAR(100)  ; 
	DECLARE c_cur_pro_name                 VARCHAR(100)  ; 
	DECLARE sposition1                    INTEGER;
	DECLARE sposition2                    INTEGER;
	DECLARE  mysubstr                      VARCHAR(100);
	DECLARE  starttimes                    INTEGER;
	DECLARE   times                       INTEGER default 1;
	DECLARE  splitStr                      VARCHAR(10);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		ROLLBACK ;
		SET @v_name=CONCAT('error sql: ',@error_sql);
		set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''-1'',\"',@v_name,'\")');
		PREPARE  execE FROM @v_log_table_sql;
		EXECUTE   execE;
		DEALLOCATE PREPARE execE;
	END ;
	    
	set c_log_table_name:='PRO_EXEC_LOG'; 
	set c_cur_pro_name :='pro_createIndex'; 
	SET starttimes := 1;
	SET sposition1 := 1;
	SET splitStr := ':';
	start transaction;
		c_loop:LOOP 	
			set sposition2 := locate(splitStr,fileds,starttimes );
			IF  sposition2 = 0  THEN
				LEAVE c_loop;
			END IF;
			set mysubstr   := substring(fileds, sposition1, sposition2 - sposition1);
			if mysubstr is null THEN
				LEAVE c_loop;
			end if;
			set @v_sql1:=concat('create index ',tabName,'_',times ,' on ',tabName,'(',mysubstr,') ');
			set @error_sql=@v_sql1;

			prepare  execs from @v_sql1;
			EXECUTE   execs;
			deallocate prepare execs;
			set times=times+1;
			set sposition1 := sposition2 + 1;
			set starttimes := sposition2 + 1;
		end loop;
	commit;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_createTable
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_createTable`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_createTable`(in tabName   VARCHAR(500),in filedAndType   VARCHAR(500),in indexfileds   varchar(500))
    DETERMINISTIC
BEGIN
	DECLARE c_log_table_name VARCHAR (100);
	DECLARE c_cur_pro_name VARCHAR (100);
	declare v_sql            VARCHAR(5000);
	DECLARE partition_name    VARCHAR(64);
	DECLARE end_date            VARCHAR(64);
	DECLARE idx  INT DEFAULT 1;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		ROLLBACK ;
		CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,'-1',CONCAT(tabName,'error'));
	END ;

	SET c_log_table_name ='PRO_EXEC_LOG';
	SET c_cur_pro_name ='pro_createTable';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(tabName,' begin'));
	SET idx := idx+1;
	
	select MAX(T.PARTITION_DESCRIPTION) INTO end_date from information_schema.`PARTITIONS`  t WHERE t.TABLE_SCHEMA = 'nms' and t.PARTITION_NAME LIKE 'NMS_PARTITION_%';
	select t.PARTITION_NAME INTO partition_name from information_schema.`PARTITIONS`  t WHERE t.TABLE_SCHEMA = 'nms' and t.PARTITION_NAME LIKE 'NMS_PARTITION_%' AND t.PARTITION_DESCRIPTION = end_date LIMIT 1;

	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(tabName,'表创建 begin'));
	SET idx := idx+1;
	set v_sql :=concat('create table ',tabName ,'(`ID` bigint(20) NOT NULL AUTO_INCREMENT ,detection_info_id bigint not null ,',filedAndType,
											',DETECTIONED_STATE varchar(2),SEQ_ID int,DETECTION_SET_INFO_ID bigint,data_check_time DATETIME,data_arrive_time DATETIME,data_check_time_digital bigint,data_arrive_time_digital bigint, 
											PRIMARY KEY(id,data_check_time)) 
											PARTITION BY RANGE (to_days(`DATA_CHECK_TIME`)) 
											(PARTITION `NMS_INIT_PARTITION` VALUES LESS THAN (737060) ,PARTITION ',partition_name,' VALUES LESS THAN ( ' ,end_date ,' ))');
	
	SELECT v_sql;
	PREPARE  execs FROM v_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	commit;
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(tabName,'表创建 end'));
	SET idx := idx+1;

	call pro_createindex(tabName,indexfileds);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(tabName,' end'));
	SET idx := idx+1;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_createTable_RST_FD
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_createTable_RST_FD`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_createTable_RST_FD`()
    DETERMINISTIC
BEGIN
	declare c_oracle_data_dir              VARCHAR(200); 
     
     DECLARE c_tablespace_init_size         VARCHAR(10) ; 
    DECLARE c_tablespace_extend_size       VARCHAR(10); 
    DECLARE c_log_table_name               VARCHAR(100); 
    DECLARE c_cur_pro_name                 VARCHAR(100) ; 
    DECLARE v_create_tablespace_sql       VARCHAR(5000);
    DECLARE v_log_table_sql               VARCHAR(5000);
    DECLARE v_sql1                        VARCHAR(5000);
    DECLARE part_time                     VARCHAR(64);
    DECLARE part_time_format              VARCHAR(64);
    DECLARE part_time2                    VARCHAR(64);
    DECLARE part_time2_format             VARCHAR(64);
    DECLARE tabName  VARCHAR(100);
    DECLARE filedAndType  VARCHAR(1000);
    DECLARE indexfileds varchar(1000);
     DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		     ROLLBACK;          
			 
			SET @v_name=CONCAT('error:',IFNULL(@error_sql,''));
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,'-1',@v_name);		    
		  END ;
	  
	  
    set c_oracle_data_dir  :='/data/d4/oradata/ict/nmspartition/';
    set c_tablespace_init_size :='10M';
    set c_tablespace_extend_size :='5M';
    set c_log_table_name  :='PRO_EXEC_LOG';
    set c_cur_pro_name :='pro_createTable_RST_FD';
    SET tabName:='DI_RST_FD';
    SET filedAndType:='rst_fd_log Number';
    SET indexfileds:='data_check_time:seq_id:detection_set_info_id:rst_fd_log:';
    
    start transaction;
    
   
 
     set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''3'',''3.查询当前时间 begin'')');
    set  @error_sql=@v_log_table_sql;
        PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
     
     
     select date_format(now(),'%Y') into part_time from dual;
     select DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s') into part_time_format from dual;
     set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''4'',''4.查询当前时间:',part_time,' end'')');
      SET  @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
     
 
    
 
     set @v_log_table_sql := concat('INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''7'',''7.查询第二天的时间 begin'')');
      SET  @error_sql=@v_log_table_sql;
    PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
     
     
      SELECT DATE_FORMAT(ADDDATE(NOW(),1),'%Y') into part_time2 from dual;
    SELECT DATE_FORMAT(ADDDATE(NOW(),1),'%Y-%m-%d %H:%i:%s')  into part_time2_format from dual;
     set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''8'',''8.查询第二天的时间:',part_time2,' end'')');
      SET  @error_sql=@v_log_table_sql;
    PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
      

  

     set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''11'',''11.建表 begin'')');
      SET  @error_sql=@v_log_table_sql;
     PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
    
     
     set @v_sql1 :=concat('create table ',tabName ,'(id int not null ,detection_info_id int not null ,',filedAndType,',DETECTIONED_STATE varchar(2),SEQ_ID int,DETECTION_SET_INFO_ID int,data_check_time DATETIME,data_arrive_time DATE,data_check_time_digital int,data_arrive_time_digital int, PRIMARY KEY(id,data_check_time),foreign KEY(detection_info_id) REFERENCES detection_info(id))',
              'partition by range(to_days(DATA_CHECK_TIME))','(partition ',tabName,'_',part_time,' values less than( TO_DAYS(''',part_time_format,''')) ',
                                                      'partition ',tabName,'_',part_time2,' values less than( TO_DAYS(''',part_time2_format,'''))) ');
     SET  @error_sql=@v_log_table_sql;
     PREPARE  execs FROM @v_sql1;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	
     set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''12'',''12.建表 end'')');
         SET  @error_sql=@v_log_table_sql;
     PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;

    set   @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''17'',''17.创建索引 begin'')');
    SET  @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
    
     
    call pro_createindex(tabName,indexfileds);
    set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''18'',''18.创建索引 end'')');
     SET  @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
     COMMIT;
    
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_createTrigger
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_createTrigger`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_createTrigger`(tabName  VARCHAR(50))
    DETERMINISTIC
BEGIN
    declare c_log_table_name               VARCHAR(100); 
    DECLARE c_cur_pro_name                 VARCHAR(100) ; 
    DECLARE v_log_table_sql               VARCHAR(5000);
    DECLARE v_sql1                        VARCHAR(5000);
     DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		    ROLLBACK ;
		    
		     SET  @v_log_table_sql := CONCAT( 'INSERT INTO ',c_log_table_name,'(id,proname,sequence,log_cont) VALUES(SEQ_PRO_EXEC_LOG.nextval,''',c_cur_pro_name,''',''1'',''1.创建触发器的SQL语句:',v_sql1,''')');
		    PREPARE  execE FROM @v_log_table_sql;
		    EXECUTE   execE;
		   DEALLOCATE PREPARE execE;
		  END ;
    
    set c_log_table_name  :='PRO_EXEC_LOG';
    set c_cur_pro_name :='pro_createTrigger';
     
  
     set @v_sql1 :=concat('Create   Trigger B_I_',tabName ,' before insert on ',tabName,' for each row
             
              begin
             
              end ;');
   
  
    PREPARE  execs FROM @v_sql1;
    EXECUTE   execs;
    DEALLOCATE PREPARE execs;
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_DELETE_SWITCHPORT
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_DELETE_SWITCHPORT`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_DELETE_SWITCHPORT`()
BEGIN
  
  DELETE T.* FROM DI_SWITCHPORT T WHERE TIMESTAMPDIFF(HOUR,SYSDATE(),T.DATA_CHECK_TIME) > 6;
  COMMIT;
  DELETE D.* FROM DETECTION_INFO D WHERE TIMESTAMPDIFF(HOUR,SYSDATE(),D.DATA_CHECK_TIME) > 6 AND D.DETECTION_SET_INFO_ID in (select t.id FROM detection_set_info t LEFT JOIN check_type_info c on c.id = t.check_type_id WHERE c.table_name = 'DI_SWITCHPORT');
  COMMIT;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_DELTABSPACE
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_DELTABSPACE`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_DELTABSPACE`(v_par_sequence  VARCHAR(100),v_cur_sql  VARCHAR(200))
    DETERMINISTIC
BEGIN
	
  declare c_log_table_name               VARCHAR(100); 
  DECLARE c_cur_pro_name                 VARCHAR(100); 

  DECLARE v_table_name                  VARCHAR(2000); 
  DECLARE v_partition_name              VARCHAR(2000); 
  declare c_table_name			 VARCHAR(200);
  declare c_partition_name		 VARCHAR(200);
   DECLARE  done  	  		INT DEFAULT 0;
  DECLARE v_sequence_count              int; 
  DECLARE v_full_sequence               VARCHAR(100);
  
  DECLARE  v_log_id                 int;

  DECLARE cur CURSOR FOR 
   SELECT table_name,partition_name FROM   pro_deltabspace_temp;
 
 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1; 
   DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		     ROLLBACK;          
			SET @v_name=CONCAT('error',IFNULL(@error_sql,''));  			 
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,'-1',@v_name);		    
		  END ;
	  
  set c_log_table_name :='PRO_EXEC_LOG';
  set c_cur_pro_name :='PRO_DELTABSPACE';
  set v_sequence_count :=0;
    START TRANSACTION;
    SET @create_name=CONCAT('create table pro_deltabspace_temp as ',v_cur_sql);
    SELECT @create_name;
    PREPARE  execs FROM @create_name;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	
 OPEN cur;
  cursor_loop:LOOP 	
    FETCH cur INTO c_table_name,c_partition_name;
    IF done=1 THEN	 
			LEAVE cursor_loop;		
		END IF;
     
     set  v_table_name :=c_table_name;
     set     v_partition_name :=c_partition_name;
     
      set  v_full_sequence :=concat( v_par_sequence,v_sequence_count);
        set @v_count=concat(v_sequence_count,'.删除',v_table_name,'表指定的表空间和表分区 begin') ;
       call   PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,v_full_sequence,@v_count);
          
          set @v_full_count=concat(v_full_sequence,'_');
         call pro_del_part_by_day(v_table_name,@v_full_count,v_partition_name);
          set v_sequence_count := v_sequence_count + 1;
          set v_full_sequence := concat(v_par_sequence,v_sequence_count);
         SET @v_count_end=CONCAT(v_sequence_count,'.删除',v_table_name,'表指定的表空间和表分区 end') ;
        call  PRO_RECORD_LOG_INFO(c_log_table_name,v_log_id,c_cur_pro_name,v_full_sequence,@v_count_end);     
    END LOOP cursor_loop;	   
		 
	  CLOSE cur;
	  
	SET @drop_name=CONCAT('drop table temp');
	set @error_sql= @drop_name;
	    SELECT @drop_name;
	     PREPARE  execs FROM @drop_name;
	    EXECUTE   execs;		   
		DEALLOCATE PREPARE execs;
	COMMIT;
  
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_DELTABSPACE_NAME
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_DELTABSPACE_NAME`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_DELTABSPACE_NAME`(tempstr   VARCHAR(50),user_name   VARCHAR(20),tablename  VARCHAR(50))
    DETERMINISTIC
BEGIN
	 
	DECLARE proexecinfoid int;
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		    ROLLBACK ;
		    set  @error='execute PRO_DELTABSPACE_NAME  error';
		    select @error;
		  END ;
	
	set @space_sql :=concat('alter table ',user_name,'.',tablename,' drop partition ',tempstr );
	PREPARE  execs FROM @space_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_del_Partition
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_del_Partition`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_del_Partition`()
    DETERMINISTIC
BEGIN
	declare	C_DATE            VARCHAR(64);
	DECLARE tempstr           VARCHAR(64);
	DECLARE user_name         VARCHAR(64);
	DECLARE space_sql         VARCHAR(1024);
	DECLARE isExist           INT;
	
 
	SELECT DATE_FORMAT(DATE_ADD(SYSDATE(),INTERVAL 7 DAY), '%Y') INTO C_DATE FROM DUAL;
	
	 
	SELECT WEEKOFYEAR(DATE_ADD(SYSDATE(),INTERVAL 7 DAY)) INTO tempstr  FROM DUAL;
	
	
	if tempstr = 1
		then SELECT DATE_FORMAT (SUBDATE(now(),7),'%Y') INTO C_DATE FROM DUAL;
	
	end if;
	
	set tempstr := cast(tempstr as unsigned int)-3;
	
	set tempstr :=concat( 'NMS_DI_W',C_DATE,'',tempstr);
	
	SELECT SUBSTRING(DEFINER,1,(SELECT LOCATE('@',DEFINER,1)-1   FROM information_schema.routines WHERE routine_schema='nms' AND routine_type='PROCEDURE' AND SPECIFIC_NAME='pro_DRIVER_ADD_Partition'))  into user_name FROM information_schema.routines WHERE routine_schema='nms' AND routine_type='PROCEDURE' AND SPECIFIC_NAME='pro_del_Partition';
	
	
	
	SET @execute_sql=CONCAT('SELECT @isExist:=count(*)  FROM information_schema.PARTITIONS WHERE table_schema=','''nms''',' AND partition_name=''',tempstr,'');
	
	 
	 if @isExist>0 then 
  
  
  call PRO_DEL_WEEK_TABSPACE(tempstr,user_name);
  
  
	SET FOREIGN_KEY_CHECKS=0;
  
  
  set @space_sql :=concat('alter table detection_info drop partition ',tempstr,'   ');
	PREPARE  execs FROM @space_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
  
 
  SET FOREIGN_KEY_CHECKS=1;
  
 
end if;
  
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_del_part_by_day
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_del_part_by_day`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_del_part_by_day`(v_table_name   VARCHAR(50),v_par_sequence   VARCHAR(20),v_partition_name   VARCHAR(20))
    DETERMINISTIC
BEGIN
	  declare  c_table_name_prefix       VARCHAR(100); 
	  DECLARE c_log_table_name          VARCHAR(100); 
	  DECLARE c_cur_pro_name            VARCHAR(100);  
	   
	  DECLARE v_del_partition_sql      VARCHAR(2000); 
	  DECLARE v_log_id                 int;
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		     ROLLBACK;          
		       SET @v_name=CONCAT('error',IFNULL(@error_sql,''));
			 
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,'-1',@v_name);		    
		  END ;
	  
	  	  
	  set   c_table_name_prefix:='';
	  set   c_log_table_name :='PRO_EXEC_LOG';
	  set  c_cur_pro_name :='pro_del_part_by_day';
	  
	   set @v_sequence=concat(v_par_sequence,'3' );
	   SET @v_name=CONCAT('3.删除',v_table_name,'表分区 begin');	 	   
	   call PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,@v_sequence,@v_name);
   
   set @v_del_partition_sql := concat('alter table ',v_table_name,' drop partition ',v_partition_name);
    SET  @error_sql=@v_del_partition_sql;
	PREPARE  execs FROM @v_del_partition_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	COMMIT;
	
	SET @v_sequence=CONCAT(v_par_sequence,'4' );
	SET @v_name=CONCAT('4.删除',v_table_name,'表分区 end');
        CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,@v_sequence,@v_name);
   
  
   
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_DEL_WEEK_TABSPACE
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_DEL_WEEK_TABSPACE`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_DEL_WEEK_TABSPACE`(tempstr   VARCHAR(20),user_name   VARCHAR(20))
    DETERMINISTIC
BEGIN
    
   declare  space_sql VARCHAR(5000);

   declare proexecinfoid int;
   declare c_segment_name varchar(50);
    DECLARE  done  	  INT DEFAULT 0;
	
   declare cur Cursor  for
	  
	 SELECT DISTINCT table_name FROM information_schema.`PARTITIONS` WHERE table_name  <> 'DETECTION_INFO' AND table_schema='nms' AND partition_name=tempstr;
         
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
	 OPEN cur;
	     start transaction;
	cursor_loop:LOOP 		
	  
	     FETCH cur INTO c_segment_name;
		IF done=1 THEN	 
			LEAVE cursor_loop;		
		END IF;
	  
	set @space_sql :=concat('alter table ',c_segment_name,' drop partition ',tempstr );
	PREPARE  execs FROM @space_sql;
	EXECUTE   execs;		   
	DEALLOCATE PREPARE execs;
	
	 	END LOOP cursor_loop;	   
		COMMIT;
	  CLOSE cur;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_driver_add_day_Partition
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_driver_add_day_Partition`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_driver_add_day_Partition`()
    DETERMINISTIC
BEGIN
	
   declare c_log_table_name      VARCHAR(100)  ; 
   DECLARE c_cur_pro_name        VARCHAR(100) ; 
 
  DECLARE v_log_table_sql        VARCHAR(2000);
  DECLARE v_table_name            VARCHAR(2000); 
   DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	  BEGIN
	  ROLLBACK;
		SET @v_name=CONCAT('error:',IFNULL(@error_sql,''));
		 SET @v_log_table_sql= CONCAT('INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES( ''',c_cur_pro_name,''',''-1'',',@v_name,')');
			
		SELECT @insert_pro;
		PREPARE execE FROM @insert_pro;
		EXECUTE execE;
		DEALLOCATE PREPARE execE;
		COMMIT;
		
		
	  END ;
  SET c_log_table_name:='PRO_EXEC_LOG';
  SET c_cur_pro_name:='pro_driver_add_Partition';
  
  
 start transaction;
   SET v_table_name :='DETECTION_INFO';
   SET @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''1'',''1.为',v_table_name,'表创建表空间和表分区 begin'')');
   set @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
	   
   
   call pro_add_part_one_day(v_table_name,'1_');
   set @v_log_table_sql :=concat(  'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''2'',''2.为',v_table_name,'表创建表空间和表分区 end'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
 
   set v_table_name :='DETECTION_INFO_WARNING';
   set @v_log_table_sql :=concat(  'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''3'',''3.为',v_table_name,'表创建表空间和表分区 begin'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
  
   call pro_add_part_one_day(v_table_name,'3_');
   set @v_log_table_sql :=  concat('INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''4'',''4.为',v_table_name,'表创建表空间和表分区 end'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
 
   set v_table_name :='DI_SYSTEMINFO_DISK';
   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''5'',''5.为',v_table_name,'表创建表空间和表分区 begin'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
   
   call pro_add_part_one_day(v_table_name,'5_');
   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''6'',''6.为',v_table_name,'表创建表空间和表分区 end'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
   
 
   set v_table_name :='DI_SYSTEMINFO_NET';
   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''7'',''7.为',v_table_name,'表创建表空间和表分区 begin'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
 
   
   call pro_add_part_one_day(v_table_name,'7_');
   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''8'',''8.为',v_table_name,'表创建表空间和表分区 end'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
 
 

   set @v_log_table_sql := concat( 'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''9'',''9.为动态表创建表空间及分区 begin'')');
    SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
   
   call pro_extendtabspace('9_','test');
  set  @v_log_table_sql :=concat(  'INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES(''',c_cur_pro_name,''',''10'',''10.为动态表创建表空间及分区 end'')');
   SET @error_sql=@v_log_table_sql;
	PREPARE  execs FROM @v_log_table_sql;
	EXECUTE   execs;
	DEALLOCATE PREPARE execs;
   COMMIT;
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_driver_add_Partition
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_driver_add_Partition`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_driver_add_Partition`()
    DETERMINISTIC
BEGIN
	DECLARE c_log_table_name VARCHAR (100);
	DECLARE c_cur_pro_name VARCHAR (100);
	DECLARE v_log_table_sql VARCHAR (2000);
	DECLARE v_table_name VARCHAR (2000);
	DECLARE v_cur_year VARCHAR (20);
	DECLARE v_cur_week VARCHAR (20);
	DECLARE end_date VARCHAR (20);
	DECLARE tempstr VARCHAR (100);
	DECLARE space_path VARCHAR (500);
	DECLARE space_sql VARCHAR (500);
	DECLARE c_oracle_data_dir VARCHAR (500);
	DECLARE execute_sql VARCHAR (500);
	DECLARE isExist INT;
	DECLARE idx INT;
	DECLARE _interval INT DEFAULT 1;
	SET idx := 1;
	SET c_log_table_name := 'PRO_EXEC_LOG';
	SET c_cur_pro_name := 'pro_driver_add_Partition';
	
	SELECT DATE_FORMAT(ADDDATE(SYSDATE(),INTERVAL 1 DAY), '%Y%m%d') INTO v_cur_year FROM DUAL;
	SELECT SUBDATE( CURDATE(),  - (_interval+1) ) INTO end_date FROM DUAL;
	SET tempstr := concat( 'NMS_PARTITION_', v_cur_year );

	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(c_cur_pro_name,'--> 表分区 begin',',partition_name: ',tempstr,' ,end_date : ',end_date) );
	SET idx := idx+1;	

	SET @end_date_f = CONCAT(end_date, ' 00:00:00');
	SELECT DATE_FORMAT( @end_date_f, '%Y-%m-%d %H:%i:%s' ) INTO @temp_time_end;
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,'动态表分区 begin');
	SET idx := idx+1;
	CALL pro_extendtabspace (tempstr ,@temp_time_end);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,'动态表分区 end');
	SET idx := idx+1;

	SET v_table_name := 'DETECTION_INFO';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 begin'));
	SET idx := idx+1;
	CALL pro_extenddefaulttabspace (tempstr ,@temp_time_end,v_table_name);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 end'));
	SET idx := idx+1;

	SET v_table_name := 'DETECTION_INFO_WARNING';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 begin'));
	SET idx := idx+1;
	CALL pro_extenddefaulttabspace (tempstr ,@temp_time_end,v_table_name);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 end'));
	SET idx := idx+1;

	SET v_table_name := 'DI_SYSTEMINFO_DISK';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 begin'));
	SET idx := idx+1;
	CALL pro_extenddefaulttabspace (tempstr ,@temp_time_end,v_table_name);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 end'));
	SET idx := idx+1;

	SET v_table_name := 'DI_SYSTEMINFO_NET';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 begin'));
	SET idx := idx+1;
	CALL pro_extenddefaulttabspace (tempstr ,@temp_time_end,v_table_name);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 end'));


	SET v_table_name := 'nms_error_info';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 begin'));
	SET idx := idx+1;
	CALL pro_extenddefaulttabspace (tempstr ,@temp_time_end,v_table_name);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 end'));

	SET v_table_name := 'email_table';
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 begin'));
	SET idx := idx+1;
	CALL pro_extenddefaulttabspace (tempstr ,@temp_time_end,v_table_name);
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(v_table_name,'表创建表空间和表分区 end'));
	SET idx := idx+1;	

	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT(c_cur_pro_name,'表分区 end') );

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_driver_add_week_Partition
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_driver_add_week_Partition`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_driver_add_week_Partition`()
    DETERMINISTIC
BEGIN

 
  declare  c_log_table_name  VARCHAR(100) ; 
  DECLARE c_cur_pro_name     VARCHAR(100) ; 
 
   
  DECLARE c_oracle_data_dir  VARCHAR(200) ; 
 
  DECLARE v_log_table_sql    VARCHAR(2000);
   
  DECLARE  C_DATE            VARCHAR(64);
  DECLARE  tempstr           VARCHAR(64);
  DECLARE  space_path        varchar(1000); 
  DECLARE  end_date          VARCHAR(32);
  
   DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	  BEGIN
	  ROLLBACK;
		SET @v_name=CONCAT('error:',IFNULL(@error_sql,''));
		 SET @v_log_table_sql= CONCAT('INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES( ''',c_cur_pro_name,''',''-1'',',@v_name,')');
		SELECT @insert_pro;
		PREPARE execE FROM @insert_pro;
		EXECUTE execE;
		DEALLOCATE PREPARE execE;
		COMMIT;
		
		
	  END ;
  
  set c_log_table_name :='PRO_EXEC_LOG';
  set c_cur_pro_name :='pro_driver_add_week_Partition';
  set c_oracle_data_dir:='/data/d4/oradata/ict/nmspartition/';
  
  

select DATE_FORMAT(now(), '%Y') into C_DATE from dual;

 SELECT WEEKOFYEAR(SYSDATE())  into tempstr from dual;

 SELECT SUBDATE(CURDATE(),DATE_FORMAT(CURDATE(),'%w')-7) into end_date from dual;
 start TRANSACTION;
    
    
    
     set tempstr :=concat( 'DI_W',C_DATE,'',tempstr);
     set space_path := CONCAT(c_oracle_data_dir,tempstr,'.dbf');
    
   

    
    
    set @end_date_f=concat(end_date,' 00:00:00');
    select date_format(@end_date_f ,'%Y-%m-%d %H:%i:%s') into  @temp_time_end;
   
  
  select  @end_date_f;
    select @temp_time_end;
    select tempstr;
    select space_path;
    
   call  pro_week_extendtabspace(tempstr, @temp_time_end);
    
   CALL pro_extenddefaulttabspace(tempstr, @temp_time_end ,'detection_info');
     
   CALL pro_extenddefaulttabspace(tempstr, @temp_time_end,'detection_info_warning');
   CALL pro_extenddefaulttabspace(tempstr, @temp_time_end,'di_systeminfo_disk');
   CALL pro_extenddefaulttabspace(tempstr, @temp_time_end,'di_systeminfo_net');
   
   commit;
   
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_driver_del_Partition
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_driver_del_Partition`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_driver_del_Partition`()
    DETERMINISTIC
BEGIN

	declare c_log_table_name          VARCHAR(100) ; 
	DECLARE c_cur_pro_name            VARCHAR(100); 
	DECLARE c_day                     int default 7; 
	DECLARE v_del_date               VARCHAR(200);
 
  declare c_table_name			 VARCHAR(200);
  declare c_partition_name		 VARCHAR(200);
	DECLARE  done  	  		INT DEFAULT 0;
	DECLARE v_cur_sql                VARCHAR(2000);
	DECLARE idx INT;

	
	DECLARE cur CURSOR FOR SELECT table_name,partition_name FROM   pro_deltabspace_temp;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1; 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		ROLLBACK;          
		SET @v_name=CONCAT('error',IFNULL(@error_sql,''));  			 
		CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,'-1',@v_name);		    
	END ;

	SET idx := 1;
	set c_log_table_name :='PRO_EXEC_LOG';
	set c_cur_pro_name := 'pro_driver_del_Partition';
		
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,'begin');	
	SET idx := idx +1;


	
	select TO_DAYS(SUBDATE(CURDATE(),INTERVAL c_day DAY)) INTO @v_del_date  from dual;
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT('分区删除时间： ',@v_del_date,' ',FROM_DAYS(@v_del_date)));	
	SET idx := idx +1;
	
	DROP VIEW IF EXISTS  nms.pro_deltabspace_temp;
	SET v_cur_sql = CONCAT('create view `nms`.`pro_deltabspace_temp` as SELECT TABLE_NAME,PARTITION_NAME FROM information_schema.`PARTITIONS` t WHERE t.TABLE_SCHEMA = ''nms'' and PARTITION_NAME LIKE ''NMS_PARTITION_%'' AND PARTITION_DESCRIPTION < ',@v_del_date);
	PREPARE stmt1 from v_cur_sql;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

	OPEN cur;
		cursor_loop:LOOP 	
			FETCH cur INTO c_table_name,c_partition_name;
			IF done=1 THEN	 
				LEAVE cursor_loop;		
			END IF;

			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT('删除分区： ',c_partition_name,',表 ： ',c_table_name,' begin'));	
			SET idx := idx +1;
			SET v_cur_sql = CONCAT('ALTER TABLE ',c_table_name,' DROP PARTITION ',c_partition_name);
			SET @error_sql = v_cur_sql;
			PREPARE stmt from v_cur_sql;
			EXECUTE  stmt;		   
			DEALLOCATE PREPARE stmt;
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,CONCAT('删除分区： ',c_partition_name,',表 ： ',c_table_name,' end'));	
			SET idx := idx +1;		

		END LOOP cursor_loop;	   
	CLOSE cur;
	CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,'end');	

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_extenddefaulttabspace
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_extenddefaulttabspace`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_extenddefaulttabspace`(spaceName   VARCHAR(100),partstr   VARCHAR(100),tableName   VARCHAR(100))
    DETERMINISTIC
BEGIN
		declare space_sql VARCHAR(5000);
		DECLARE execParm int;
		DECLARE proexecinfoid int;
		declare newday  datetime;
		DECLARE c_log_table_name               VARCHAR(100); 
		DECLARE c_cur_pro_name                 VARCHAR(100) ;
		DECLARE idx INT;
		

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			SET @v_name=CONCAT(' error sql: ' ,ifnull(@error_sql,''));
			SET @v_log_table_sql= CONCAT('INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES( ''',c_cur_pro_name,''',''-1'',''', @v_name, ''')');    
			PREPARE execE FROM @v_log_table_sql;
			EXECUTE execE;
			DEALLOCATE PREPARE execE;
			COMMIT;
		END;


		SET idx := 1;
		set c_log_table_name   :='PRO_EXEC_LOG';
		set c_cur_pro_name :='pro_extenddefaulttabspace';
		set  execParm := 0;
	 
		SET @execute_sql = concat( 'SELECT count(*) into @isExist FROM information_schema.PARTITIONS WHERE table_schema=', '''nms''', ' AND partition_name=''', spaceName, '''',' AND table_name=''', tableName, '''');
		PREPARE execs
		FROM @execute_sql;
		EXECUTE execs;
		DEALLOCATE PREPARE execs;
		IF @isExist = 0 THEN
			START TRANSACTION;
				SELECT DATE_FORMAT(NOW(),'%Y%-%m-%d %H:%i:%s') INTO newday;
				set @space_sql :=CONCAT('alter table ',tableName,' add partition (PARTITION  ',spaceName,  ' values less than ( TO_DAYS(''',partstr,''')));');
				set @error_sql := @space_sql;
				PREPARE  execs FROM @space_sql;
				EXECUTE   execs;
				DEALLOCATE PREPARE execs;
			COMMIT;
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,concat(spaceName,'-',tableName ,'创建成功'));
			SET idx := idx+1;
		ELSE
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,concat(spaceName,'-',tableName ,'已创建'));
			SET idx := idx+1;
		END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_EXTENDTABSPACE
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_EXTENDTABSPACE`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_EXTENDTABSPACE`(spaceName   VARCHAR(100),partstr   VARCHAR(100))
    DETERMINISTIC
BEGIN
	declare	space_sql VARCHAR(5000);
	DECLARE	execParm int;
	DECLARE	v_log_table_sql               VARCHAR(2000);
	DECLARE c_log_table_name               VARCHAR(100); 
	DECLARE c_cur_pro_name                 VARCHAR(100) ; 
	declare c_table_name			varchar(30);
	DECLARE  done INT DEFAULT 0 ;
	DECLARE idx INT;
	
	DECLARE cur Cursor  for select cti.table_name  extendtabName from check_type_info cti where cti.crete_state = 0; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1 ;	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		ROLLBACK;
		SET @v_name=CONCAT(' error sql: ' ,ifnull(@error_sql,'') );
		select @v_name;
		SET @v_log_table_sql= CONCAT('INSERT INTO ',c_log_table_name,'(proname,sequence,log_cont) VALUES( ''',c_cur_pro_name,''',''-1'',\"',execParm, @v_name, '\")');    
		SELECT @v_log_table_sql;
		PREPARE execE FROM @v_log_table_sql;
		EXECUTE execE;
		DEALLOCATE PREPARE execE;
		COMMIT;
	END ;
	set c_log_table_name   :='PRO_EXEC_LOG';
	set c_cur_pro_name :='PRO_EXTENDTABSPACE';    
	SET execParm := 0;
	SET idx := 1;

	OPEN cur ;  
		START TRANSACTION;
		cursor_loop:LOOP 
		FETCH cur      INTO c_table_name;
		IF done = 1    THEN 
			LEAVE cursor_loop ;
		END IF ;
		SET @execute_sql = concat( 'SELECT count(*) into @isExist FROM information_schema.PARTITIONS WHERE table_schema=', '''nms''', ' AND partition_name=''', spaceName, '''',' AND table_name=''', c_table_name, '''');
		PREPARE execs
		FROM @execute_sql;
		EXECUTE execs;
		DEALLOCATE PREPARE execs;
		IF @isExist = 0 THEN
			CALL pro_extenddefaulttabspace (spaceName ,partstr,c_table_name);
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,concat(spaceName,'-',c_table_name,'创建成功'));
			SET idx := idx+1;
		ELSE
			CALL PRO_RECORD_LOG_INFO(c_log_table_name,c_cur_pro_name,idx,concat(spaceName,'-',c_table_name,'已创建'));
			SET idx := idx+1;
		END IF;
		SET execParm := 3;
		END LOOP cursor_loop ;
		COMMIT;
	CLOSE cur;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_RECORD_LOG_INFO
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_RECORD_LOG_INFO`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_RECORD_LOG_INFO`(log_table_name  VARCHAR(100), proname  VARCHAR(100), sequence  VARCHAR(100),log_cont  VARCHAR(100))
    DETERMINISTIC
BEGIN
	declare v_log_table_sql          VARCHAR(2000);
	set @v_log_table_sql :=  concat('INSERT INTO ',log_table_name,'(proname,sequence,log_cont) VALUES(''',proname,''',''',sequence,''',''',log_cont,''')');
    PREPARE  execs FROM @v_log_table_sql;
    EXECUTE   execs;
    DEALLOCATE PREPARE execs;
    COMMIT;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for pro_updatedetectiontable
-- ----------------------------
DROP PROCEDURE IF EXISTS `pro_updatedetectiontable`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `pro_updatedetectiontable`()
    DETERMINISTIC
BEGIN
	  declare tablename VARCHAR(100);
	  DECLARE hasPk     int         ;
	  DECLARE hasId     int         ;
	  DECLARE dsiId     int         ;
	   DECLARE  done    INT DEFAULT 0;
	   declare c_table_name varchar(100);
	  
	  declare tableName_cursor CURSOR  for
	  select TABLE_NAME from check_type_info cti WHERE 1=1 AND cti.crete_state=0 ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;	
	               
	               
	   DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		    ROLLBACK ;
		 
		    set @error=concat(c_table_name,'表修改失败');
		    select @error;
		  END ;
	  set hasPk=0;
	  set hasId=0;
	  set dsiId=0;
	
	 OPEN tableName_cursor;  
	 start transaction;
	 loopLable:LOOP
		FETCH tableName_cursor INTO c_table_name;    
		IF done=1 THEN
			LEAVE loopLable;
		END IF;
		
	      set tablename := c_table_name;
	      set @truncate_table= CONCAT('truncate table ',tablename);
	      
	       PREPARE  execs FROM @truncate_table;
	       EXECUTE   execs;
	       DEALLOCATE PREPARE execs;
	     
	      SELECT IFNULL(COUNT(*),0)  INTO hasPk FROM information_schema.`TABLE_CONSTRAINTS` WHERE   TABLE_NAME=tablename AND constraint_type='PRIMARY KEY';
	      select IFNULL(count(*),0) INTO hasId from information_schema.`COLUMNS` utc where utc.TABLE_NAME = tablename AND utc.column_name='ID';
	      select IFNULL(count(*),0) INTO dsiId from information_schema.`COLUMNS` utc where utc.TABLE_NAME = tablename AND utc.column_name='DETECTION_SET_INFO_ID';
	      IF(dsiId =0)
	      THEN
		  set @exe_alter_add= CONCAT('alter table ',tablename , ' add (DETECTION_SET_INFO_ID int) ;');
		   PREPARE  execs FROM   @exe_alter_add;
		 
		   EXECUTE   execs;
	           DEALLOCATE PREPARE execs;
	      END IF;
	      IF(hasPk =1)
	      THEN
		    SET @exe_alter_drop=CONCAT('alter table ', tablename , ' drop Primary key ;');
		   PREPARE  execs FROM  @exe_alter_drop;
		   
		   EXECUTE   execs;
	           DEALLOCATE PREPARE execs;
	      END IF;
	      IF(hasId =0)
	      THEN
		    SET @exe_alter_apk= CONCAT('alter table ', tablename , ' add (ID int  Primary key) ;');
		   PREPARE  execs FROM  @exe_alter_apk;		 
		   EXECUTE   execs;
	           DEALLOCATE PREPARE execs;
	      ELSE
	       SET @exe_alter_apki=CONCAT('alter table ', tablename , ' add Primary key(ID) ;');
		  PREPARE  execs FROM @exe_alter_apki;
		   EXECUTE   execs;
	           DEALLOCATE PREPARE execs;
	      END IF;
	      
	     
	    
	 
	 END LOOP loopLable;
	 commit;
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for PRO_WEEK_EXTENDTABSPACE
-- ----------------------------
DROP PROCEDURE IF EXISTS `PRO_WEEK_EXTENDTABSPACE`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `PRO_WEEK_EXTENDTABSPACE`(spaceName   VARCHAR(100),partstr   VARCHAR(100))
    DETERMINISTIC
BEGIN
	declare space_sql VARCHAR(5000);
	DECLARE execParm int;
	DECLARE proexecinfoid int;
	DECLARE c_table_name VARCHAR(50);
	declare newday      datetime;
	DECLARE done        INT DEFAULT 0 ;
	
	
	  
	DECLARE  cur Cursor  for
	
		 select cti.table_name  extendtabName
		 from check_type_info cti where cti.crete_state = 0;
	 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1 ;	
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		  BEGIN
		  ROLLBACK;
			 set @insert_pro= CONCAT('insert into PROEXECINFO(proname,param,prodesc) values(','''PRO_EXTENDTABSPACE'',''',execParm,''',''',newday,' tablename:',c_table_name,' partitionName:' ,spaceName,' partContent:',partstr,''')');
			 select @insert_pro;
			PREPARE execE from @insert_pro;
			EXECUTE execE;
			DEALLOCATE PREPARE execE;
			COMMIT;
			
			
		  END ;
	   
	 select DATE_FORMAT(NOW(),'%Y%-%m-%d %H:%i:%s') into newday;	 
        set execParm := 0;
	  OPEN cur ;
	  
	   START TRANSACTION;
	  cursor_loop:LOOP 
	    FETCH cur      INTO c_table_name;
	     IF done = 1    THEN 
		    LEAVE cursor_loop ;
	     END IF ;
	    set execParm := 1;
	    set @space_sql :=concat('alter table ',c_table_name,' add partition (PARTITION  ',spaceName,  ' values less than ( TO_DAYS(''',partstr,''')));');
 
	      
	    select @space_sql;
	    set execParm := 2;
	    PREPARE  execs FROM @space_sql;
	    EXECUTE   execs;
	    DEALLOCATE PREPARE execs;
	   
	    set execParm := 3;
	  
	   END LOOP cursor_loop ;
	    COMMIT;
	  CLOSE cur;
    
	  
    END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for setDetectInfoDateTime
-- ----------------------------
DROP PROCEDURE IF EXISTS `setDetectInfoDateTime`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` PROCEDURE `setDetectInfoDateTime`(IN `addHour` smallint)
BEGIN

	

update detection_info t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.INSERT_DB_TIME=ADDDATE(t.INSERT_DB_TIME,INTERVAL addHour HOUR),

					t.NEXT_CHECK_TIME=ADDDATE(t.NEXT_CHECK_TIME,INTERVAL addHour HOUR),

					t.STATUS_CHANGE_TIME=ADDDATE(t.STATUS_CHANGE_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

  update detection_info_new t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.NEXT_CHECK_TIME=ADDDATE(t.NEXT_CHECK_TIME,INTERVAL addHour HOUR),

					t.STATUS_CHANGE_TIME=ADDDATE(t.STATUS_CHANGE_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

 update delect_info_nmsc t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_cpu t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_disk t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_memory t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_netdata t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_ping t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_port t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;



update detect_info_process t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_snmp_trap t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update detect_info_system_date t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;





update di_switchport t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;

update di_system t set t.DATA_ARRIVE_TIME=ADDDATE(t.DATA_ARRIVE_TIME,INTERVAL addHour HOUR),

					t.DATA_CHECK_TIME=ADDDATE(t.DATA_CHECK_TIME,INTERVAL addHour HOUR),

					t.DATA_ARRIVE_TIME_DIGITAL=t.DATA_ARRIVE_TIME_DIGITAL+60*60*1000*addHour,

					t.DATA_CHECK_TIME_DIGITAL=t.DATA_CHECK_TIME_DIGITAL+60*60*1000*addHour;



END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for currval
-- ----------------------------
DROP FUNCTION IF EXISTS `currval`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` FUNCTION `currval`(seq_name VARCHAR(50)) RETURNS bigint(21)
    READS SQL DATA
BEGIN
    DECLARE VALUE BIGINT; 
    SET VALUE=0; 
    SELECT current_value INTO VALUE 
    FROM sys_sequence  
    WHERE NAME=seq_name; 
    RETURN VALUE; 
    END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for getParentList
-- ----------------------------
DROP FUNCTION IF EXISTS `getParentList`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` FUNCTION `getParentList`(groupid INT) RETURNS varchar(512) CHARSET utf8
BEGIN 
       DECLARE pTemp VARCHAR(512);  
       DECLARE cTemp VARCHAR(512);  
      
       SET pTemp = '0';  
       SET cTemp =cast(groupid as CHAR);  
      
       WHILE cTemp is not null DO  
         SET pTemp = concat(pTemp,',',cTemp);  
         SELECT group_concat(parent_group_id) INTO cTemp FROM nodegroup_table  
         WHERE FIND_IN_SET(group_id,cTemp)>0; 
                
       END WHILE;  
       RETURN pTemp;  
     END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for getParentList_bak
-- ----------------------------
DROP FUNCTION IF EXISTS `getParentList_bak`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` FUNCTION `getParentList_bak`(groupid INT) RETURNS varchar(512) CHARSET utf8
BEGIN 
       DECLARE pTemp VARCHAR(512);  
       DECLARE cTemp VARCHAR(512);  
      
       SET pTemp = '0';  
       SET cTemp =cast(groupid as CHAR);  
      
       WHILE cTemp is not null DO  
         SET pTemp = concat(pTemp,',',cTemp);  
         SELECT group_concat(parent_group_id) INTO cTemp FROM nodegroup_table  
         WHERE FIND_IN_SET(group_id,cTemp)>0; 
                
       END WHILE;  
       RETURN pTemp;  
     END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for getPIds
-- ----------------------------
DROP FUNCTION IF EXISTS `getPIds`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` FUNCTION `getPIds`(sid varchar(10)) RETURNS varchar(512) CHARSET utf8
BEGIN
DECLARE cr_stack_depth INTEGER DEFAULT cr_debug.ENTER_MODULE2('getPIds', 'nms', 8, 100632) ;
  DECLARE pid varchar(10);
  DECLARE pids varchar(512);
  CALL cr_debug.UPDATE_WATCH3('sid', sid, 'varchar(10)', cr_stack_depth) ;
CALL cr_debug.UPDATE_WATCH3('pid', pid, 'varchar(10)', cr_stack_depth) ;
CALL cr_debug.UPDATE_WATCH3('pids', pids, 'varchar(512)', cr_stack_depth) ;
CALL cr_debug.TRACE(3, 3, 0, 5, cr_stack_depth) ;
CALL cr_debug.TRACE(6, 6, 2, 14, cr_stack_depth) ;
set pid:='';
CALL cr_debug.UPDATE_WATCH3('pid', pid, '', cr_stack_depth) ;
  CALL cr_debug.TRACE(7, 16, 2, 12, cr_stack_depth) ;
WHILE pid <>'0' DO
    CALL cr_debug.TRACE(8, 12, 4, 11, cr_stack_depth) ;
if(pid ='') THEN 
      CALL cr_debug.TRACE(9, 9, 6, 20, cr_stack_depth) ;
set pids:=pid;
CALL cr_debug.UPDATE_WATCH3('pids', pids, '', cr_stack_depth) ;
    ELSE 
      CALL cr_debug.TRACE(11, 11, 6, 37, cr_stack_depth) ;
set pids:=CONCAT(pids,',',pid);
CALL cr_debug.UPDATE_WATCH3('pids', pids, '', cr_stack_depth) ;
    END IF;

    CALL cr_debug.TRACE(14, 14, 4, 85, cr_stack_depth) ;
SELECT nt.parent_group_id INTO pid FROM nodegroup_table nt WHERE nt.group_id=sid;
CALL cr_debug.UPDATE_SYSTEM_CALLS(101) ;
CALL cr_debug.UPDATE_WATCH3('pid', pid, '', cr_stack_depth) ;
    CALL cr_debug.TRACE(15, 15, 4, 17, cr_stack_depth) ;
set sid:=pid;
CALL cr_debug.UPDATE_WATCH3('sid', sid, '', cr_stack_depth) ;
  END WHILE;
  CALL cr_debug.TRACE(17, 17, 2, 14, cr_stack_depth) ;
SET @devart_debug_ret = pids ;
CALL cr_debug.LEAVE_MODULE(cr_stack_depth - 1) ;
RETURN @devart_debug_ret;
  CALL cr_debug.TRACE(18, 18, 2, 5, cr_stack_depth) ;
CALL cr_debug.LEAVE_MODULE(cr_stack_depth - 1) ;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for getPIds_bak
-- ----------------------------
DROP FUNCTION IF EXISTS `getPIds_bak`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` FUNCTION `getPIds_bak`(sid varchar(10)) RETURNS varchar(512) CHARSET utf8
BEGIN
DECLARE cr_stack_depth INTEGER DEFAULT cr_debug.ENTER_MODULE2('getPIds', 'nms', 8, 100632) ;
  DECLARE pid varchar(10);
  DECLARE pids varchar(512);
  CALL cr_debug.UPDATE_WATCH3('sid', sid, 'varchar(10)', cr_stack_depth) ;
CALL cr_debug.UPDATE_WATCH3('pid', pid, 'varchar(10)', cr_stack_depth) ;
CALL cr_debug.UPDATE_WATCH3('pids', pids, 'varchar(512)', cr_stack_depth) ;
CALL cr_debug.TRACE(3, 3, 0, 5, cr_stack_depth) ;
CALL cr_debug.TRACE(6, 6, 2, 14, cr_stack_depth) ;
set pid:='';
CALL cr_debug.UPDATE_WATCH3('pid', pid, '', cr_stack_depth) ;
  CALL cr_debug.TRACE(7, 16, 2, 12, cr_stack_depth) ;
WHILE pid <>'0' DO
    CALL cr_debug.TRACE(8, 12, 4, 11, cr_stack_depth) ;
if(pid ='') THEN 
      CALL cr_debug.TRACE(9, 9, 6, 20, cr_stack_depth) ;
set pids:=pid;
CALL cr_debug.UPDATE_WATCH3('pids', pids, '', cr_stack_depth) ;
    ELSE 
      CALL cr_debug.TRACE(11, 11, 6, 37, cr_stack_depth) ;
set pids:=CONCAT(pids,',',pid);
CALL cr_debug.UPDATE_WATCH3('pids', pids, '', cr_stack_depth) ;
    END IF;

    CALL cr_debug.TRACE(14, 14, 4, 85, cr_stack_depth) ;
SELECT nt.parent_group_id INTO pid FROM nodegroup_table nt WHERE nt.group_id=sid;
CALL cr_debug.UPDATE_SYSTEM_CALLS(101) ;
CALL cr_debug.UPDATE_WATCH3('pid', pid, '', cr_stack_depth) ;
    CALL cr_debug.TRACE(15, 15, 4, 17, cr_stack_depth) ;
set sid:=pid;
CALL cr_debug.UPDATE_WATCH3('sid', sid, '', cr_stack_depth) ;
  END WHILE;
  CALL cr_debug.TRACE(17, 17, 2, 14, cr_stack_depth) ;
SET @devart_debug_ret = pids ;
CALL cr_debug.LEAVE_MODULE(cr_stack_depth - 1) ;
RETURN @devart_debug_ret;
  CALL cr_debug.TRACE(18, 18, 2, 5, cr_stack_depth) ;
CALL cr_debug.LEAVE_MODULE(cr_stack_depth - 1) ;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for nextval
-- ----------------------------
DROP FUNCTION IF EXISTS `nextval`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` FUNCTION `nextval`(seq_name varchar(50)) RETURNS bigint(21)
    READS SQL DATA
BEGIN
     UPDATE sys_sequence 
     SET CURRENT_VALUE = CURRENT_VALUE + INCREMENT 
     where  name=seq_name; 
     return currval(seq_name); 
     END
;;
DELIMITER ;

-- ----------------------------
-- Event structure for add_partition_everyday
-- ----------------------------
DROP EVENT IF EXISTS `add_partition_everyday`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` EVENT `add_partition_everyday` ON SCHEDULE EVERY 1 DAY STARTS '2018-05-18 23:30:00' ON COMPLETION PRESERVE ENABLE DO CALL pro_driver_add_Partition()
;;
DELIMITER ;

-- ----------------------------
-- Event structure for del_partition_everyday
-- ----------------------------
DROP EVENT IF EXISTS `del_partition_everyday`;
DELIMITER ;;
CREATE DEFINER=`nms`@`%` EVENT `del_partition_everyday` ON SCHEDULE EVERY 1 DAY STARTS '2018-05-17 01:00:00' ON COMPLETION PRESERVE ENABLE DO CALL pro_driver_del_Partition()
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_cti_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_cti_index` AFTER UPDATE ON `check_type_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='check_type_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_cti_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_cti_index` AFTER DELETE ON `check_type_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='check_type_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_dpr_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_dpr_index` AFTER UPDATE ON `data_police_relation` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='data_police_relation';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_dpr_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_dpr_index` AFTER DELETE ON `data_police_relation` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='data_police_relation';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_din_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_din_index` AFTER UPDATE ON `detection_info_new` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='detection_info_new';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_diw_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_diw_index` AFTER UPDATE ON `detection_info_warning` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=2,target_id=old.id,table_name='detection_info_warning';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_dsi_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_dsi_index` AFTER UPDATE ON `detection_set_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.ID,table_name='detection_set_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_dsi_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_dsi_index` AFTER DELETE ON `detection_set_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.ID,table_name='detection_set_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_di_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_di_index` AFTER UPDATE ON `device_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.device_id,table_name='device_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_di_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_di_index` AFTER DELETE ON `device_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.device_id,table_name='device_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_dt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_dt_index` AFTER UPDATE ON `dictionary_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='dictionary_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_dt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_dt_index` AFTER DELETE ON `dictionary_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='dictionary_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `BEFORE_INSERT_EMAIL_TABLE`;
DELIMITER ;;
CREATE TRIGGER `BEFORE_INSERT_EMAIL_TABLE` BEFORE INSERT ON `email_table` FOR EACH ROW BEGIN
IF NEW.id is NULL or NEW.id = 0 THEN
     SET  NEW.id =( select nextval('SEQ_EMAIL_TABLE'));
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_et_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_et_index` AFTER UPDATE ON `email_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='email_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_et_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_et_index` AFTER DELETE ON `email_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='email_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `before_insert_event_record`;
DELIMITER ;;
CREATE TRIGGER `before_insert_event_record` BEFORE INSERT ON `event_record_library` FOR EACH ROW BEGIN
IF NEW.id IS NULL or NEW.id = 0 THEN
     SET  NEW.id =( select nextval('SEQ_EVENT_RECORD_LIBRARY'));
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `afterinsert_event_record_library`;
DELIMITER ;;
CREATE TRIGGER `afterinsert_event_record_library` AFTER INSERT ON `event_record_library` FOR EACH ROW BEGIN
          if new.sync_status!=1 then
	insert into table_event_log set event=1,target_id=new.id,table_name='event_record_library';
          end if;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `afterupdate_event_record_library`;
DELIMITER ;;
CREATE TRIGGER `afterupdate_event_record_library` AFTER UPDATE ON `event_record_library` FOR EACH ROW BEGIN
              if old.sync_status!=1 then
	     insert into table_event_log set event=2,target_id=old.id,table_name='event_record_library';
              end if;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `afterdelete_event_record_library`;
DELIMITER ;;
CREATE TRIGGER `afterdelete_event_record_library` AFTER DELETE ON `event_record_library` FOR EACH ROW BEGIN
              if old.sync_status!=1 then
	     insert into table_event_log set event=3,target_id=old.id,table_name='event_record_library';
              end if;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_far_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_far_index` AFTER UPDATE ON `flow_audit_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.seq,table_name='flow_audit_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_far_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_far_index` AFTER DELETE ON `flow_audit_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.seq,table_name='flow_audit_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_gst_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_gst_index` AFTER UPDATE ON `gorup_system_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='gorup_system_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_gst_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_gst_index` AFTER DELETE ON `gorup_system_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='gorup_system_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_iu_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_iu_index` AFTER UPDATE ON `img_url` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='img_url';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_iu_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_iu_index` AFTER DELETE ON `img_url` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='img_url';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `before_insert_loopmission_state_table`;
DELIMITER ;;
CREATE TRIGGER `before_insert_loopmission_state_table` BEFORE INSERT ON `loopmission_state_table` FOR EACH ROW BEGIN
    
    set new.cur_mission_id := CONCAT(new.mission_id,UNIX_TIMESTAMP(new.start_time));

END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_insert_lst_index`;
DELIMITER ;;
CREATE TRIGGER `after_insert_lst_index` AFTER INSERT ON `loopmission_state_table` FOR EACH ROW BEGIN
           insert into table_event_log set event=1,target_id=new.cur_mission_id,table_name='loopmission_state_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_lst_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_lst_index` AFTER UPDATE ON `loopmission_state_table` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=2,target_id=old.cur_mission_id,table_name='loopmission_state_table';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_lst_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_lst_index` AFTER DELETE ON `loopmission_state_table` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=3,target_id=old.cur_mission_id,table_name='loopmission_state_table';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_metadata_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_metadata_index` AFTER UPDATE ON `metadata` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='metadata';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_metadata_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_metadata_index` AFTER DELETE ON `metadata` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='metadata';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_mfi_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_mfi_index` AFTER UPDATE ON `mission_file_information` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='mission_file_information';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_mfi_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_mfi_index` AFTER DELETE ON `mission_file_information` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='mission_file_information';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `BEFORE_UPDATE_MISSION_RESULT_1`;
DELIMITER ;;
CREATE TRIGGER `BEFORE_UPDATE_MISSION_RESULT_1` BEFORE UPDATE ON `mission_result_table1` FOR EACH ROW BEGIN
	 
	if old.result <> new.result then
	if (new.result <> -1 and ((old.result = 0) or (old.result = 1) or (new.result is null))) then
	set new.result := old.result;
     end if;
	end if;
  
  if old.result_desc <> new.result_desc then
  set new.result_desc := concat(ifnull(old.result_desc,''),ifnull(new.result_desc,''));
  end if;
    END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_mrt1_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_mrt1_index` AFTER UPDATE ON `mission_result_table1` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=2,target_id=old.id,table_name='mission_result_table1';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `BEFORE_UPDATE_MISSION_RESULT_4`;
DELIMITER ;;
CREATE TRIGGER `BEFORE_UPDATE_MISSION_RESULT_4` BEFORE UPDATE ON `mission_result_table4` FOR EACH ROW BEGIN
	 
  
  
  
  
  
  
  
  
  
  
   if   new.result is null THEN
     
     set new.result = old.result;
  end if;
  if  old.result <> new.result THEN
     
     if (new.result in (5,6,7)) then
        if (old.result = 7) then
          set new.result := old.result;
        end if;
     else
     
        if (old.result in (5,6,7)) then
           set new.result := old.result;
        else
           
           if (new.result <> -1 and ((old.result = 0) or (old.result = 1) or (new.result is null)))  then
              set new.result := old.result;
           end if;
        end if;
     end if;
  end if;
  
  if new.result_desc is null or new.result_desc<>old.result_desc then
     if old.result_desc is not null and new.result_desc is not null and instr(old.result_desc,new.result_desc)>0 then  
        set new.result_desc := ifnull(old.result_desc,'');
     else 
        set new.result_desc :=concat(ifnull(old.result_desc,''),ifnull(new.result_desc,''));
     end if;
  end if;
  
  if new.file_info  is null or  new.file_info <> old.file_info THEN
     if (old.file_info is not NULL) then
         if(new.file_info is not null) then
             set new.file_info :=concat(ifnull(old.file_info,''),'@@@',ifnull(new.file_info,''));
         else
             set new.file_info := ifnull(old.file_info,'');
         end if;
     end if;
  end if;
    END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_mrt4_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_mrt4_index` AFTER UPDATE ON `mission_result_table4` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=2,target_id=old.id,table_name='mission_result_table4';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `BEFORE_UPDATE_MISSION_RESULT_6`;
DELIMITER ;;
CREATE TRIGGER `BEFORE_UPDATE_MISSION_RESULT_6` BEFORE UPDATE ON `mission_result_table6` FOR EACH ROW BEGIN
 
  if new.result<> old.result then
     if (new.result <> -1 and ((old.result = 0) or (old.result = 1) or (new.result is null))) then
        set new.result := old.result;
     end if;
  end if;
  
  if new.result_desc<> old.result then
   set new.result_desc := concat(ifnull(old.result_desc,''),ifnull(new.result_desc,''));
  end if;
    END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_mrt6_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_mrt6_index` AFTER UPDATE ON `mission_result_table6` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=2,target_id=old.id,table_name='mission_result_table6';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `BEFORE_UPDATE_MISSION_STATE_T`;
DELIMITER ;;
CREATE TRIGGER `BEFORE_UPDATE_MISSION_STATE_T` BEFORE UPDATE ON `mission_state_table` FOR EACH ROW BEGIN
	 if new.AUTO_DESC<> old.AUTO_DESC then
        SET new.AUTO_DESC := CONCAT(IFNULL(old.AUTO_DESC,''),chAr(10),IFNULL(new.AUTO_DESC,''));
     end if;
    END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_mst_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_mst_index` AFTER UPDATE ON `mission_state_table` FOR EACH ROW BEGIN
            
         insert into table_event_log set event=2,target_id=old.id,table_name='mission_state_table';
            
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nec_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nec_index` AFTER UPDATE ON `nms_error_code` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='nms_error_code';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nec_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nec_index` AFTER DELETE ON `nms_error_code` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='nms_error_code';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `BEFORE_NMS_ERROE_INFO`;
DELIMITER ;;
CREATE TRIGGER `BEFORE_NMS_ERROE_INFO` BEFORE INSERT ON `nms_error_info` FOR EACH ROW BEGIN
	IF(new.state_update_time IS NULL)
	THEN
		set new.state_update_time = new.error_time;
	END IF;
IF NEW.id is NULL or NEW.id = 0 THEN
     SET  NEW.id =( select nextval('SEQ_NMS_ERROR_INFO'));
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nei_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nei_index` AFTER UPDATE ON `nms_error_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='nms_error_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nei_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nei_index` AFTER DELETE ON `nms_error_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='nms_error_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nap_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nap_index` AFTER UPDATE ON `nodegroup_arrow_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='nodegroup_arrow_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nap_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nap_index` AFTER DELETE ON `nodegroup_arrow_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='nodegroup_arrow_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nbp_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nbp_index` AFTER UPDATE ON `nodegroup_bgimg_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='nodegroup_bgimg_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nbp_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nbp_index` AFTER DELETE ON `nodegroup_bgimg_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='nodegroup_bgimg_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_ngp_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_ngp_index` AFTER UPDATE ON `nodegroup_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='nodegroup_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_ngp_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_ngp_index` AFTER DELETE ON `nodegroup_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='nodegroup_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `node_group_table_tri`;
DELIMITER ;;
CREATE TRIGGER `node_group_table_tri` BEFORE INSERT ON `nodegroup_table` FOR EACH ROW begin 
	declare parent_group_ids_temp varchar(512);
	select parent_group_ids into parent_group_ids_temp from nodegroup_table where group_id=new.parent_group_id;
	if(parent_group_ids_temp is null or parent_group_ids_temp ='') then 
	set	new.parent_group_ids := concat('0',',');
	else 
	set new.parent_group_ids := concat(parent_group_ids_temp,new.parent_group_id,',');
	end if;
IF NEW.group_id is NULL or NEW.group_id = 0 THEN
     SET  NEW.group_id  =( select nextval('SEQ_NODEGROUP_TABLE'));
END IF;
end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_ngt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_ngt_index` AFTER UPDATE ON `nodegroup_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.group_id,table_name='nodegroup_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_ngt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_ngt_index` AFTER DELETE ON `nodegroup_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.group_id,table_name='nodegroup_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nbt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nbt_index` AFTER UPDATE ON `node_box_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.box_id,table_name='node_box_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nbt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nbt_index` AFTER DELETE ON `node_box_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.box_id,table_name='node_box_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nfi_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nfi_index` AFTER UPDATE ON `node_figure_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='node_figure_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nfi_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nfi_index` AFTER DELETE ON `node_figure_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='node_figure_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nlt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nlt_index` AFTER UPDATE ON `node_lattice_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='node_lattice_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nlt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nlt_index` AFTER DELETE ON `node_lattice_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='node_lattice_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_np_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_np_index` AFTER UPDATE ON `node_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='node_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_np_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_np_index` AFTER DELETE ON `node_position` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='node_position';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nrlt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nrlt_index` AFTER UPDATE ON `node_room_lattice_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='node_room_lattice_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nrlt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nrlt_index` AFTER DELETE ON `node_room_lattice_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='node_room_lattice_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nrt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nrt_index` AFTER UPDATE ON `node_room_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.room_id,table_name='node_room_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `adter_delete_nrt_index`;
DELIMITER ;;
CREATE TRIGGER `adter_delete_nrt_index` AFTER DELETE ON `node_room_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.room_id,table_name='node_room_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `before_insert_node_table`;
DELIMITER ;;
CREATE TRIGGER `before_insert_node_table` BEFORE INSERT ON `node_table` FOR EACH ROW begin
IF NEW.node_id is NULL or NEW.node_id = 0 THEN
     SET  NEW.node_id =( select nextval('SEQ_NODE_TABLE'));
END IF;
end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_nt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_nt_index` AFTER UPDATE ON `node_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.node_id,table_name='node_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `AFTER_DELETE_NODE_TABLE`;
DELIMITER ;;
CREATE TRIGGER `AFTER_DELETE_NODE_TABLE` AFTER DELETE ON `node_table` FOR EACH ROW begin
   declare  v_cnt INT;
   select count(*) into v_cnt from node_table n where n.seq_id=OLD.seq_id;
   if v_cnt=0 then
         update node_lattice_table t set t.node_seq=null where t.node_seq=OLD.seq_id;
    end if;
end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_nt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_nt_index` AFTER DELETE ON `node_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.node_id,table_name='node_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_od_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_od_index` AFTER UPDATE ON `oid_dictionary` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='oid_dictionary';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_od_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_od_index` AFTER DELETE ON `oid_dictionary` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='oid_dictionary';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_oar_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_oar_index` AFTER UPDATE ON `operate_audit_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.seq,table_name='operate_audit_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_oar_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_oar_index` AFTER DELETE ON `operate_audit_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.seq,table_name='operate_audit_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_opt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_opt_index` AFTER UPDATE ON `option_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='option_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_opt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_opt_index` AFTER DELETE ON `option_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='option_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_ot_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_ot_index` AFTER UPDATE ON `order_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.command_id,table_name='order_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_ot_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_ot_index` AFTER DELETE ON `order_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.command_id,table_name='order_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_pi_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_pi_index` AFTER UPDATE ON `plugin_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='plugin_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_pi_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_pi_index` AFTER DELETE ON `plugin_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='plugin_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_pl_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_pl_index` AFTER UPDATE ON `procedure_log` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='procedure_log';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_pl_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_pl_index` AFTER DELETE ON `procedure_log` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='procedure_log';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_proexecinfo_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_proexecinfo_index` AFTER UPDATE ON `proexecinfo` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='proexecinfo';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_proexecinfo_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_proexecinfo_index` AFTER DELETE ON `proexecinfo` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='proexecinfo';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_pel_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_pel_index` AFTER UPDATE ON `pro_exec_log` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='pro_exec_log';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_detele_pel_index`;
DELIMITER ;;
CREATE TRIGGER `after_detele_pel_index` AFTER DELETE ON `pro_exec_log` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='pro_exec_log';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_sis_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_sis_index` AFTER UPDATE ON `server_ip_segment` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='server_ip_segment';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_sis_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_sis_index` AFTER DELETE ON `server_ip_segment` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='server_ip_segment';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_st_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_st_index` AFTER UPDATE ON `server_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='server_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_st_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_st_index` AFTER DELETE ON `server_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='server_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_sddc_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_sddc_index` AFTER UPDATE ON `set_det_data_con` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='set_det_data_con';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_sddc_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_sddc_index` AFTER DELETE ON `set_det_data_con` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='set_det_data_con';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_si_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_si_index` AFTER UPDATE ON `sort_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='sort_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_si_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_si_index` AFTER DELETE ON `sort_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='sort_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_scc_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_scc_index` AFTER UPDATE ON `system_company_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.config_id,table_name='system_company_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_scc_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_scc_index` AFTER DELETE ON `system_company_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.config_id,table_name='system_company_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_sgc_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_sgc_index` AFTER UPDATE ON `system_gateway_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.config_id,table_name='system_gateway_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_sgc_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_sgc_index` AFTER DELETE ON `system_gateway_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.config_id,table_name='system_gateway_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_sic_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_sic_index` AFTER UPDATE ON `system_ip_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.config_id,table_name='system_ip_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_sic_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_sic_index` AFTER DELETE ON `system_ip_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.config_id,table_name='system_ip_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_spc_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_spc_index` AFTER UPDATE ON `system_proxy_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.config_id,table_name='system_proxy_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_spc_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_spc_index` AFTER DELETE ON `system_proxy_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.config_id,table_name='system_proxy_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_src_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_src_index` AFTER UPDATE ON `system_route_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.config_id,table_name='system_route_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_src_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_src_index` AFTER DELETE ON `system_route_config` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.config_id,table_name='system_route_config';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_syst_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_syst_index` AFTER UPDATE ON `system_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.system_id,table_name='system_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_syst_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_syst_index` AFTER DELETE ON `system_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.system_id,table_name='system_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_sddi_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_sddi_index` AFTER UPDATE ON `sys_data_dictionary_item` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='sys_data_dictionary_item';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_sddi_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_sddi_index` AFTER DELETE ON `sys_data_dictionary_item` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='sys_data_dictionary_item';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_sddn_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_sddn_index` AFTER UPDATE ON `sys_data_dictionary_name` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='sys_data_dictionary_name';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_sddn_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_sddn_index` AFTER DELETE ON `sys_data_dictionary_name` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='sys_data_dictionary_name';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tbrpt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tbrpt_index` AFTER UPDATE ON `tabledboperationrpt` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.logid,table_name='tabledboperationrpt';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tbrpt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tbrpt_index` AFTER DELETE ON `tabledboperationrpt` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.logid,table_name='tabledboperationrpt';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `tabledepartment_before_insert`;
DELIMITER ;;
CREATE TRIGGER `tabledepartment_before_insert` BEFORE INSERT ON `tabledepartment` FOR EACH ROW BEGIN
IF NEW.upperlayer is NULL  or NEW.upperlayer = 0 THEN
     SET  NEW.pids = '0,';
     SET  NEW.upperlayer = 0;
ELSE
     set NEW.pids = (select concat(t.pids,t.deptid,',') from tabledepartment t where t.deptid = NEW.upperlayer);
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `tabledepartment_before_update`;
DELIMITER ;;
CREATE TRIGGER `tabledepartment_before_update` BEFORE UPDATE ON `tabledepartment` FOR EACH ROW BEGIN
IF NEW.upperlayer is NULL  or NEW.upperlayer = 0 THEN
     SET  NEW.pids = '0,';
     SET  NEW.upperlayer = 0;
ELSE
     set NEW.pids = (select concat(t.pids,t.deptid,',') from tabledepartment t where t.deptid = NEW.upperlayer);
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_td_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_td_index` AFTER UPDATE ON `tabledepartment` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.deptid,table_name='tabledepartment';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_td_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_td_index` AFTER DELETE ON `tabledepartment` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.deptid,table_name='tabledepartment';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tlrpt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tlrpt_index` AFTER UPDATE ON `tableloginrpt` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.logid,table_name='tableloginrpt';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tlrpt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tlrpt_index` AFTER DELETE ON `tableloginrpt` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.logid,table_name='tableloginrpt';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tud_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tud_index` AFTER UPDATE ON `tableuserdepartment` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='tableuserdepartment';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tud_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tud_index` AFTER DELETE ON `tableuserdepartment` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='tableuserdepartment';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tg_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tg_index` AFTER UPDATE ON `table_guide` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='table_guide';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tg_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tg_index` AFTER DELETE ON `table_guide` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='table_guide';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tci_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tci_index` AFTER UPDATE ON `topo_con_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='topo_con_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tci_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tci_index` AFTER DELETE ON `topo_con_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='topo_con_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_ti_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_ti_index` AFTER UPDATE ON `topo_img` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='topo_img';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_ti_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_ti_index` AFTER DELETE ON `topo_img` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='topo_img';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tin_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tin_index` AFTER UPDATE ON `topo_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='topo_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tin_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tin_index` AFTER DELETE ON `topo_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='topo_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tli_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tli_index` AFTER UPDATE ON `topo_line_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='topo_line_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tli_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tli_index` AFTER DELETE ON `topo_line_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='topo_line_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tni_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tni_index` AFTER UPDATE ON `topo_node_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='topo_node_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tni_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tni_index` AFTER DELETE ON `topo_node_info` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='topo_node_info';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_ts_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_ts_index` AFTER UPDATE ON `trouble_state` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='trouble_state';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_ts_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_ts_index` AFTER DELETE ON `trouble_state` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='trouble_state';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_tt_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_tt_index` AFTER UPDATE ON `type_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='type_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_tt_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_tt_index` AFTER DELETE ON `type_table` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='type_table';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_umr_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_umr_index` AFTER UPDATE ON `update_model_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.update_id,table_name='update_model_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_umr_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_umr_index` AFTER DELETE ON `update_model_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.update_id,table_name='update_model_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_ufr_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_ufr_index` AFTER UPDATE ON `upload_file_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.unique_seq,table_name='upload_file_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_ufr_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_ufr_index` AFTER DELETE ON `upload_file_rz` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.unique_seq,table_name='upload_file_rz';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_xjmi_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_xjmi_index` AFTER UPDATE ON `xt_js_mk_index` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='xt_js_mk_index';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_xjmi_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_xjmi_index` AFTER DELETE ON `xt_js_mk_index` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='xt_js_mk_index';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_xmj_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_xmj_index` AFTER UPDATE ON `xt_mk_jbxx` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='xt_mk_jbxx';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_xmj_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_xmj_index` AFTER DELETE ON `xt_mk_jbxx` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='xt_mk_jbxx';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_xyj_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_xyj_index` AFTER UPDATE ON `xt_yh_jbxx` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.yhid,table_name='xt_yh_jbxx';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_xyj_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_xyj_index` AFTER DELETE ON `xt_yh_jbxx` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.yhid,table_name='xt_yh_jbxx';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_update_xyji_index`;
DELIMITER ;;
CREATE TRIGGER `after_update_xyji_index` AFTER UPDATE ON `xt_yh_js_index` FOR EACH ROW BEGIN 
        insert into table_event_log set event=2,target_id=old.id,table_name='xt_yh_js_index';
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `after_delete_xyji_index`;
DELIMITER ;;
CREATE TRIGGER `after_delete_xyji_index` AFTER DELETE ON `xt_yh_js_index` FOR EACH ROW BEGIN 
        insert into table_event_log set event=3,target_id=old.id,table_name='xt_yh_js_index';
END
;;
DELIMITER ;
