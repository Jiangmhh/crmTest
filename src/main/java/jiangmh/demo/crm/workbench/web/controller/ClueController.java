package jiangmh.demo.crm.workbench.web.controller;

import jiangmh.demo.crm.settings.dao.UserDao;
import jiangmh.demo.crm.settings.domain.User;
import jiangmh.demo.crm.settings.service.UserService;
import jiangmh.demo.crm.utils.DateTimeUtil;
import jiangmh.demo.crm.utils.UUIDUtil;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.ActivityDao;
import jiangmh.demo.crm.workbench.dao.ClueDao;
import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.Clue;
import jiangmh.demo.crm.workbench.domain.ClueRemark;
import jiangmh.demo.crm.workbench.domain.Tran;
import jiangmh.demo.crm.workbench.service.ActivityService;
import jiangmh.demo.crm.workbench.service.ClueService;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/workbench/clue/user")
public class ClueController {
    @Resource
    private UserService userService;
    @Resource
    private ClueService clueService;
    @Resource
    private ActivityService activityService;

    @RequestMapping(value = "getUserList.do")
    @ResponseBody
    public List<User> getUserListController(){
        System.out.println("线索注入值");
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "saveClue.do")
    @ResponseBody
    public Boolean createClueController(Clue clue, HttpServletRequest request){
        System.out.println("线索添加");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        clue.setId(id);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        Boolean flag = clueService.saveClue(clue);
        return flag;
    }

    // 分页
    @RequestMapping(value = "pageList.do")
    @ResponseBody
    public PaginationVO<Clue> pageListController(String fullname, String company, String source, String owner,
                                                 String state, String phone, String mphone, Integer pageNo, Integer pageSize){
        System.out.println("线索分页展示");
        Map map = new HashMap();
        int skipCount = (pageNo-1)*pageSize;
        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("source", source);
        map.put("owner", owner);
        map.put("state", state);
        map.put("phone", phone);
        map.put("mphone", mphone);
        PaginationVO<Clue> vo = clueService.pageList(map);
        return vo;
    }

    @RequestMapping(value = "getUserListAndClue.do")
    @ResponseBody
    public Map getUserListAndClueController(String id){
        System.out.println("线索修改注入");
        Map map = new HashMap();
        List<User> userList = userService.getUserList();
        Clue clue = clueService.getClueById(id);
        map.put("userList", userList);
        map.put("clue", clue);
        return map;
    }

    @RequestMapping(value = "detail.do")
    public ModelAndView detailController(String id){
        System.out.println("线索详细信息页");
        ModelAndView mv = new ModelAndView();
        Clue clue = clueService.getDetail(id);
        mv.addObject("clue", clue);
        mv.setViewName("forward:/workbench/clue/detail.jsp");
        return mv;
    }

    @RequestMapping(value = "getActivityByClueId.do")
    @ResponseBody
    public List<Activity> getActivityByClueIdController(String id){
        System.out.println("线索-市场活动展示");
        List<Activity> a = activityService.getActivityByClueId(id);
        return a;
    }

    @RequestMapping(value = "deleteRelationById.do")
    @ResponseBody
    public Boolean deleteRelationByIdController(String id){
        System.out.println("线索-市场活动解除关联");
        Boolean flag = clueService.deleteRelationById(id);
        return flag;
    }

    @RequestMapping(value = "getActivityListByNameAndNotCid.do")
    @ResponseBody
    public List<Activity> getActivityListByNameAndNotCidController(String name, String clueId){
        System.out.println("线索-市场活动绑定展示");
        List<Activity> a = activityService.getActivityListByNameAndNotCid(name,clueId);
        return a;
    }

    @RequestMapping(value = "bundActivity.do")
    @ResponseBody
    public Boolean bundActivityController(String aids, String clueId){
        System.out.println("线索-市场活动绑定");
        String str = aids.replace("id=","");
        String ids[] = str.split("&");
        Boolean f = clueService.bundActivity(ids, clueId);
        return f;
    }

    // 展示所有线索
    @RequestMapping(value = "getActivityByName.do")
    @ResponseBody
    public List<Activity> getActivityByNameController(String name){
        System.out.println("转换-市场活动展示所有");
        List<Activity> list = activityService.getActivityByName(name);
        return list;
    }

    // 转换
    @RequestMapping(value = "convert.do")
    public ModelAndView convertController(String clueId, String name, String money, String expectedDate, String stage,
                                            String activityId, String flag,  HttpServletRequest request){
        System.out.println("转换");
        ModelAndView mv = new ModelAndView();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        Tran t = null;
        if(!"a".equals(flag)){
            t = new Tran();
            t.setName(name);
            t.setMoney(money);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setCreateTime(createTime);
        }
        Boolean f = clueService.convert(clueId, t, createBy);
        if(f){
            mv.setViewName("redirect:/workbench/clue/index.jsp");
        }else{
            mv.setViewName("forward:/workbench/clue/convert.jsp");
        }
        return mv;
    }

    // 线索更新
    @RequestMapping(value = "updateClue.do")
    @ResponseBody
    public Boolean updateClueController(Clue clue, HttpServletRequest request){
        System.out.println("线索-修改");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        Boolean f = clueService.update(clue);
        return f;
    }

    @RequestMapping(value = "delete.do")
    @ResponseBody
    public Boolean deleteController(String[] id){
        System.out.println("线索-删除（联系的备注删除）");
        Boolean f = clueService.delete(id);
        return f;
    }

    // 展示线索备注
    @RequestMapping(value = "getRemarkListByCid.do")
    @ResponseBody
    public List<ClueRemark> getRemarkListByCidController(String clueId){
        System.out.println("线索-展示线索备注");
        List<ClueRemark> list = clueService.getRemarkListByCid(clueId);
        return list;
    }

    // 线索备注修改
    @RequestMapping(value = "updateRemark.do")
    @ResponseBody
    public Boolean updateRemarkController(ClueRemark clueRemark){
        System.out.println("线索-线索备注修改");
        boolean f = clueService.updateRemark(clueRemark);
        return f;
    }

    // 线索备注删除
    @RequestMapping(value = "deleteRemark.do")
    @ResponseBody
    public Boolean deleteRemarkController(String id){
        System.out.println("线索-线索备注删除");
        boolean f = clueService.deleteById(id);
        return f;
    }

    // 线索备注添加
    @RequestMapping(value = "saveRemark.do")
    @ResponseBody
    public Boolean saveRemarkController(ClueRemark clueRemark, HttpServletRequest request){
        System.out.println("线索-线索备注添加");
        clueRemark.setId(UUIDUtil.getUUID());
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("0");
        boolean f = clueService.saveRemark(clueRemark);
        return f;
    }


}
