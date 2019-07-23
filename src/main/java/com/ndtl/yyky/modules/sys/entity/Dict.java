package com.ndtl.yyky.modules.sys.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.validator.constraints.Length;

import com.ndtl.yyky.common.persistence.DataEntity;

/**
 * 字典Entity
 */
@Entity
@Table(name = "sys_dict")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Dict extends DataEntity {

    private static final long serialVersionUID = 1L;
    private Long id; // 编号
    private String label; // 标签名
    private String value; // 数据值
    private String type; // 类型
    private String description;// 描述
    private Integer sort; // 排序

    public Dict() {
        super();
    }

    public Dict(Long id) {
        this();
        this.id = id;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    // @GeneratedValue(strategy = GenerationType.SEQUENCE, generator =
    // "seq_sys_dict")
    // @SequenceGenerator(name = "seq_sys_dict", sequenceName = "seq_sys_dict")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    @Length(min = 1, max = 100)
    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Length(min = 1, max = 100)
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Length(min = 0, max = 100)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @NotNull
    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

}