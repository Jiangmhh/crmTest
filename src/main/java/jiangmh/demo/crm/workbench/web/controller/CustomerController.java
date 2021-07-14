package jiangmh.demo.crm.workbench.web.controller;

import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.settings.service.UserService;
import jiangmh.demo.crm.utils.DateTimeUtil;
import jiangmh.demo.crm.utils.UUIDUtil;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.domain.Contacts;
import jiangmh.demo.crm.workbench.domain.Customer;
import jiangmh.demo.crm.workbench.domain.CustomerRemark;
import jiangmh.demo.crm.workbench.domain.Tran;
import jiangmh.demo.crm.workbench.service.ContactsService;
import jiangmh.demo.crm.workbench.service.CustomerService;
import jiangmh.demo.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench/customer/user")
public class CustomerController {
    @Resource
    private UserService userService;
    @Resource
    CustomerService customerService;
    @Resource
    ContactsService contactsService;
    @Resource
    private TransactionService transactionService;

    @RequestMapping(value = "/getUserList.do")
    @ResponseBody
    public List<User> getUserListController(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "/pageList.do")
    @ResponseBody
    public PaginationVO<Customer> pageListController(String name, String owner, String phone, String website,
                                                     Integer pageSize, Integer pageNo){
        System.out.println("客户分页");
        Integer skipCount = (pageNo-1)*pageSize;
        Map map = new HashMap();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);
        PaginationVO<Customer> vo = customerService.pageList(map);
        return vo;
    }

    @RequestMapping(value = "/save.do")
    @ResponseBody
    public boolean saveController(Customer c, HttpServletRequest request){
        c.setId(UUIDUtil.getUUID());
        c.setCreateTime(DateTimeUtil.getSysTime());
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        c.setCreateBy(createBy);
        boolean f = customerService.save(c);
        return f;
    }

    // 客户注值
    @RequestMapping(value = "/getUserListAndCustomer.do")
    @ResponseBody
    public Map getUserListAndCustomerController(String id){
        Map map = customerService.getUserListAndCustomer(id);
        return map;
    }

    @RequestMapping(value = "/getCustomerById.do")
    @ResponseBody
    public Customer getCustomerByIdController(String id){
        Customer customer = customerService.getCustomerById(id);
        return customer;
    }

    // 更新
    @RequestMapping(value = "/update.do")
    @ResponseBody
    public Boolean updateController(Customer customer, HttpServletRequest request){
        customer.setEditTime(DateTimeUtil.getSysTime());
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        customer.setEditBy(editBy);
        boolean f = customerService.update(customer);
        return f;
    }

    // 删除
    @RequestMapping(value = "/delete.do")
    @ResponseBody
    public Boolean deleteController(String[] id){
        boolean f = customerService.delete(id);
        return f;
    }

    // 详细信息
    @RequestMapping(value = "/detail.do")
    @ResponseBody
    public ModelAndView detailController(String id){
        ModelAndView mv = new ModelAndView();
        Customer customer = customerService.getDtail(id);
        mv.addObject("customer", customer);
        mv.setViewName("forward:/workbench/customer/detail.jsp");
        return mv;
    }

    // 客户备注
    @RequestMapping(value = "/getRemarkListByCusid.do")
    @ResponseBody
    public List<Map<String,Object>> getRemarkListByCusidController(String id){
        List<Map<String,Object>> mapList = customerService.getRemarkListByCusid(id);
        return mapList;
    }

    // 客户备注
    @RequestMapping(value = "/updateRemark.do")
    @ResponseBody
    public boolean updateRemarkController(CustomerRemark customerRemark,HttpServletRequest request){
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        customerRemark.setEditFlag("1");
        customerRemark.setEditBy(editBy);
        customerRemark.setEditTime(DateTimeUtil.getSysTime());
        boolean f = customerService.updateRemark(customerRemark);
        return f;
    }

    // 客户备注
    @RequestMapping(value = "/deleteRemark.do")
    @ResponseBody
    public boolean deleteRemarkController(String id){
        boolean f = customerService.deleteRemark(id);
        return f;
    }

    // 客户备注
    @RequestMapping(value = "/addRemark.do")
    @ResponseBody
    public boolean addRemarkController(CustomerRemark customerRemark, HttpServletRequest request){
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        customerRemark.setId(UUIDUtil.getUUID());
        customerRemark.setCreateBy(createBy);
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());
        customerRemark.setEditFlag("0");
        boolean f = customerService.addRemark(customerRemark);
        return f;
    }

    // 联系人
    @RequestMapping(value = "/getContactListById.do")
    @ResponseBody
    public List<Contacts> getContactListByIdController(String customerId){
        List<Contacts> list = contactsService.getContactListById(customerId);
        return list;
    }

    // 交易展示
    @RequestMapping(value = "/getTranListByCusId.do")
    @ResponseBody
    public List<Tran> getTranListByCusIdController(String customerId, HttpServletRequest request){
        List<Tran> tranList = transactionService.getTranListByCusId(customerId);
        Map<String,String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for(Tran t : tranList){
            String possibility = map.get(t.getStage());
            t.setPossibility(possibility);
        }
        return tranList;
    }

    // 删除交易
    @RequestMapping(value = "/deleteTran.do")
    @ResponseBody
    public boolean deleteTranController(String id){
        boolean f = transactionService.deleteTran(id);
        return f;
    }

    // 新疆联系人
    @RequestMapping(value = "/saveContact.do")
    @ResponseBody
    public boolean saveContactController(Contacts contacts, HttpServletRequest request){
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setCreateBy(createBy);
        boolean f = contactsService.save(contacts);
        return f;
    }

    // 删除联系人
    @RequestMapping(value = "/deleteContact.do")
    @ResponseBody
    public boolean deleteContactController(String id){
        boolean f = contactsService.deleteContact(id);
        return f;
    }

}
