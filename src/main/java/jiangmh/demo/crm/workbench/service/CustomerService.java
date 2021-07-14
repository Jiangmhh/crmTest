package jiangmh.demo.crm.workbench.service;

import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.domain.Customer;
import jiangmh.demo.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    PaginationVO<Customer> pageList(Map map);

    boolean save(Customer c);

    Customer getCustomerById(String id);

    Map getUserListAndCustomer(String id);

    boolean update(Customer customer);

    boolean delete(String[] id);

    Customer getDtail(String id);

    List<Map<String, Object>> getRemarkListByCusid(String id);

    boolean updateRemark(CustomerRemark customerRemark);

    boolean deleteRemark(String id);

    boolean addRemark(CustomerRemark customerRemark);

    List<String> getCustomerName(String name);
}
