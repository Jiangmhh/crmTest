package jiangmh.demo.crm.workbench.service.impl;

import jiangmh.demo.crm.settings.dao.UserDao;
import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.CustomerDao;
import jiangmh.demo.crm.workbench.dao.CustomerRemarkDao;
import jiangmh.demo.crm.workbench.domain.Customer;
import jiangmh.demo.crm.workbench.domain.CustomerRemark;
import jiangmh.demo.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;
    @Resource
    private UserDao userDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Override
    public PaginationVO<Customer> pageList(Map map) {
        Integer total = customerDao.getCounts();
        List<Customer> list = customerDao.getCustomerByCondition(map);
        PaginationVO<Customer> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    @Override
    public boolean save(Customer c) {
        int count = customerDao.save(c);
        return count==1;
    }

    @Override
    public Customer getCustomerById(String id) {
        Customer c = customerDao.getCustomerById(id);
        return c;
    }

    @Override
    public Map getUserListAndCustomer(String id) {
        Map map = new HashMap();
        List<User> userList = userDao.getUserList();
        Customer c = customerDao.getCustomerById(id);
        map.put("userList",userList);
        map.put("c",c);
        return map;
    }

    @Override
    public boolean update(Customer customer) {
        int count = customerDao.update(customer);
        return count==1;
    }

    @Override
    public boolean delete(String[] id) {
        int count = customerDao.delete(id);
        return count==id.length;
    }

    @Override
    public Customer getDtail(String id) {
        Customer customer = customerDao.getDtail(id);
        return customer;
    }

    @Override
    public List<Map<String, Object>> getRemarkListByCusid(String id) {
        List<Map<String, Object>> mapList = customerRemarkDao.getRemarkListByCusid(id);
        return mapList;
    }

    @Override
    public boolean updateRemark(CustomerRemark customerRemark) {
        int count = customerRemarkDao.updateRemark(customerRemark);
        return count==1;
    }

    @Override
    public boolean deleteRemark(String id) {
        int count = customerRemarkDao.deleteRemark(id);
        return count==1;
    }

    @Override
    public boolean addRemark(CustomerRemark customerRemark) {
        int count = customerRemarkDao.addRemark(customerRemark);
        return count==1;
    }

    @Override
    public List<String> getCustomerName(String name) {
        List<String> list = customerDao.getCustomerName(name);
        return list;
    }


}
