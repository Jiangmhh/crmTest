package jiangmh.demo.crm.workbench.web.controller;

import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.settings.service.UserService;
import jiangmh.demo.crm.utils.DateTimeUtil;
import jiangmh.demo.crm.utils.UUIDUtil;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.CustomerDao;
import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.Contacts;
import jiangmh.demo.crm.workbench.domain.Customer;
import jiangmh.demo.crm.workbench.domain.Tran;
import jiangmh.demo.crm.workbench.service.ActivityService;
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
@RequestMapping(value = "/workbench/transaction/user")
public class TransactionController {
    @Resource
    private TransactionService transactionService;
    @Resource
    private UserService userService;
    @Resource
    private CustomerService customerService;
    @Resource
    private ActivityService activityService;
    @Resource
    private ContactsService contactsService;

    @RequestMapping(value = "/pageList.do")
    @ResponseBody
    public PaginationVO<Map> pageController(String owner, String name, String customerName, String stage,
                                            String type, String source, String contactName, Integer pageNo, Integer pageSize){
        System.out.println("执行交易展示");
        int skipCount = (pageNo-1)*pageSize;
        Map map = new HashMap();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactName",contactName);
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        PaginationVO<Map> vo = transactionService.pageList(map);
        return vo;
    }

    // 交易添加页面
    @RequestMapping(value = "/addTran.do")
    @ResponseBody
    public ModelAndView addTranController(){
        ModelAndView mv = new ModelAndView();
        List<User> userList = userService.getUserList();
        mv.addObject("userList",userList);
        mv.setViewName("forward:/workbench/transaction/save.jsp");
        return mv;
    }

    // 交易添加页面
    @RequestMapping(value = "/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerNameController(String name){
        List<String> customerList = customerService.getCustomerName(name);
        return customerList;
    }

    // 交易市场活动源
    @RequestMapping(value = "/getActivityListByName.do")
    @ResponseBody
    public List<Activity> getActivityListByNameController(String name){
        List<Activity> list = activityService.getActivityByName(name);
        return list;
    }

    // 交易联系人源
    @RequestMapping(value = "/getContactListByName.do")
    @ResponseBody
    public List<Contacts> getContactListByNameController(String name){
        List<Contacts> list = contactsService.getContactListByName(name);
        return list;
    }

    // 交易添加
    @RequestMapping(value = "/save.do")
    @ResponseBody
    public ModelAndView saveController(Tran tran, HttpServletRequest request){
        ModelAndView mv = new ModelAndView();
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        tran.setCreateBy(createBy);
        String customerName = request.getParameter("customerName");
        boolean f = transactionService.save(tran, customerName);
        if(f){
            mv.setViewName("redirect:/workbench/transaction/index.jsp");
        }
        return mv;
    }

    // 交易详细信息页
    @RequestMapping(value = "/detail.do")
    @ResponseBody
    public ModelAndView detailController(String id, HttpServletRequest request){
        ModelAndView mv = new ModelAndView();
        Map tMap = transactionService.detail(id);
        String stage = (String) tMap.get("stage");
        Map<String,String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = map.get(stage);
        tMap.put("possibility",possibility);
        mv.addObject("tMap",tMap);
        mv.setViewName("forward:/workbench/transaction/detail.jsp");
        return mv;
    }

    // 交易历史
    @RequestMapping(value = "/getTranHistoryListByTid.do")
    @ResponseBody
    public List<Map> getTranHistoryListByTidController(String tranId, HttpServletRequest request){
        List<Map> mapList = transactionService.getTranHistoryListByTid(tranId);
        Map<String,String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for(Map m : mapList){
            String possibility = map.get(m.get("stage"));
            m.put("possibility",possibility);
        }
        return mapList;
    }

    // 更改交易阶段
    @RequestMapping(value = "/changeStage.do")
    @ResponseBody
    public Map changeStageController(Tran tran, HttpServletRequest request){
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        tran.setEditBy(editBy);
        tran.setEditTime(DateTimeUtil.getSysTime());

        boolean f = transactionService.changeStage(tran);
        Map<String,String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String stage = tran.getStage();
        String possibility = map.get(stage);
        Map m = new HashMap();
        if(f){
            m.put("stage",tran.getStage());
            m.put("editBy",editBy);
            m.put("editTime",tran.getEditTime());
            m.put("possibility",possibility);
        }
        return m;
    }

    // 交易图表
    @RequestMapping(value = "/getChart.do")
    @ResponseBody
    public List<Map> getChartController(){
        List<Map> m = transactionService.getChart();
        return m;
    }

}
