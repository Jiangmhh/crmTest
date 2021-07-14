package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getValueList(String code);
}
