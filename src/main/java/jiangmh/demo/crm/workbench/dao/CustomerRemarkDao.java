package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerRemarkDao {

    int save(List<CustomerRemark> customerRemarkList);

    List<Map<String, Object>> getRemarkListByCusid(String id);

    int updateRemark(CustomerRemark customerRemark);

    int deleteRemark(String id);

    int addRemark(CustomerRemark customerRemark);
}
