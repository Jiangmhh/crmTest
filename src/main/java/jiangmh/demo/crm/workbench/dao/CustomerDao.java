package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer c);

    Integer getCounts();

    List<Customer> getCustomerByCondition(Map map);

    Customer getCustomerById(String id);

    int update(Customer customer);

    int delete(String[] id);

    Customer getDtail(String id);

    List<String> getCustomerName(String name);

    Customer getCustomerInName(String customerName);
}
