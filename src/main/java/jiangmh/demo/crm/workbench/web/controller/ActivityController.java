package jiangmh.demo.crm.workbench.web.controller;

import jiangmh.demo.crm.settings.dao.UserDao;
import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.settings.service.UserService;
import jiangmh.demo.crm.utils.DateTimeUtil;
import jiangmh.demo.crm.utils.UUIDUtil;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.ActivityDao;
import jiangmh.demo.crm.workbench.dao.ActivityRemarkDao;
import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.ActivityRemark;
import jiangmh.demo.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench/activity/user")
public class ActivityController {
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;

    // 响应ajax
    @RequestMapping(value = "/getUserList.do")
    @ResponseBody
    public List<User> getUserListController(){
        System.out.println("执行控制器");
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
    @ResponseBody
    public Boolean saveController(Activity activity,HttpServletRequest request){
        System.out.println(request.getRequestURI());
        System.out.println("执行市场活动添加");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();  // 创建时间 : 当前系统时间
        String createBy = ((User)request.getSession().getAttribute("user")).getName();  // 创建人 : 当前系统对象
        activity.setId(id);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        Map map = new HashMap();
        boolean flag = activityService.save(activity);
        return flag;
    }

    @RequestMapping(value = "/pageList.do")
    @ResponseBody
    public PaginationVO<Activity> pageController(String owner, String name,
                                                 String startDate, String endDate, Integer pageNo, Integer pageSize){
        System.out.println("执行市场活动展示");
        int skipCount = (pageNo-1)*pageSize;
        Map map = new HashMap();
        map.put("owner",owner);
        map.put("name",name);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);


        /*返回值使用map或vo  多模块有分页查询(重复功能)--vo
        {“total”:100,"dataList":[{市场活动1},{2},{3}]}
        PaginationVO<T>
            private total
            private List<T> dataList*/

        PaginationVO<Activity> vo = activityService.pageList(map);
        return vo;
    }

    @RequestMapping(value = "/delete.do")
    @ResponseBody
    public boolean deleteController(@RequestParam(value = "id") String[] ids){
        System.out.println("执行删除");
        System.out.println(ids);
        boolean flag = activityService.delete(ids);
        return flag;
    }

    // 市场活动注值
    @RequestMapping(value = "/getUserListAndActivity.do")
    @ResponseBody
    public Map getActivityController(String id){
        // 获取userList对象
        List<User> userList = userService.getUserList();
        // 获取Activity单记录
        Activity activity = activityService.getActivity(id);
        Map<String,Object> map = new HashMap();
        map.put("uList",userList);
        map.put("a",activity);
        return map;
    }

//    // 市场活动修改
    @RequestMapping(value = "/update.do")
    @ResponseBody
    public Boolean getActivityController(Activity activity, HttpServletRequest request){
        System.out.println("市场活动修改");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);
        Boolean flag = activityService.update(activity);
        return flag;
    }

    // 市场活动详细信息页
    @RequestMapping(value = "/detail.do")
    public ModelAndView getDetailController(String id){
        System.out.println("市场详细信息页");
        Activity activity = activityService.detail(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("a", activity);
        mv.setViewName("forward:/workbench/activity/detail.jsp");
        return mv;
    }

    // 市场备注展示
    @RequestMapping(value = "/getActivityRemarkByAid.do")
    @ResponseBody
    public List<ActivityRemark> getRemarkController(String id){
        System.out.println("市场备注信息页");
        List<ActivityRemark> ar = activityService.getActivityRemarkByAid(id);
        return ar;
    }

    // 市场备注删除
    @RequestMapping(value = "/deleteRemark.do")
    @ResponseBody
    public Boolean deleteRemarkController(String id){
        System.out.println("市场备注删除");
        Boolean flag = activityService.deleteRemark(id);
        return flag;
    }

    // 市场备注添加
    @RequestMapping(value = "/saveRemark.do")
    @ResponseBody
    public Boolean saveRemarkController(ActivityRemark activityRemark, HttpServletRequest request){
        System.out.println("市场备注删除");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        activityRemark.setId(id);
        activityRemark.setCreateTime(createTime);
        activityRemark.setCreateBy(createBy);
        activityRemark.setEditFlag(editFlag);
        Boolean flag = activityService.saveRemark(activityRemark);
        return flag;
    }

    // 市场备注添加
    @RequestMapping(value = "/editRemark.do")
    @ResponseBody
    public Boolean editRemarkController(ActivityRemark activityRemark, HttpServletRequest request){
        System.out.println("市场备注修改");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);
        activityRemark.setEditFlag(editFlag);
        Boolean flag = activityService.editRemark(activityRemark);
        return flag;
    }


}
