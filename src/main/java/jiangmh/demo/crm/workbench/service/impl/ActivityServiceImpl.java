package jiangmh.demo.crm.workbench.service.impl;

import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.ActivityDao;
import jiangmh.demo.crm.workbench.dao.ActivityRemarkDao;
import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.ActivityRemark;
import jiangmh.demo.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;

    @Override
    public Boolean save(Activity activity) {
        Boolean flag = true;
        int count = activityDao.save(activity);
        if(count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map map) {
        // 获取总数 total
        int total = activityDao.getTotalByCondition(map);
        // 获取 dataList
        List<Activity> dataList = activityDao.getActivityListByCondition(map);
        PaginationVO<Activity> vo = new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        for(String s : ids){
            // 查询需要删除的备注的数量
            int count1 = activityRemarkDao.getCountByAid(s);
            // 删除备注，返回收到影响的条数(实际删除的数量)
            int count2 = activityRemarkDao.deleteByAid(s);
            if(count1 != count2){
                flag = false;
            }
        }
        // 删除市场活动
        int count3 = activityDao.delete(ids);
        if(count3 != ids.length){
            flag = false;
        }

        return flag;
    }

    @Override
    public Activity getActivity(String id) {
        Activity activity = activityDao.getActivity(id);
        return activity;
    }

    @Override
    public Boolean update(Activity activity) {
        Boolean flag = activityDao.update(activity);
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity a = activityDao.getDetailById(id);
        return a;
    }

    @Override
    public List<ActivityRemark> getActivityRemarkByAid(String id) {
        List<ActivityRemark> list = activityRemarkDao.getActivityRemarkByAid(id);
        return list;
    }

    @Override
    public Boolean deleteRemark(String id) {
        Boolean flag = activityRemarkDao.deleteRemark(id);
        return flag;
    }

    @Override
    public Boolean saveRemark(ActivityRemark activityRemark) {
        Boolean flag = activityRemarkDao.saveRemark(activityRemark);
        return flag;
    }

    @Override
    public Boolean editRemark(ActivityRemark activityRemark) {
        Boolean flag = activityRemarkDao.editRemark(activityRemark);
        return flag;
    }


    @Override
    public List<Activity> getActivityByClueId(String id) {
        List<Activity> activityList = activityDao.getActivityByClueId(id);
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotCid(String name, String clueId) {
        List<Activity> activityList = activityDao.getActivityListByNameAndNotCid(name, clueId);
        return activityList;
    }

    @Override
    public List<Activity> getActivityByName(String name) {
        List<Activity> list = activityDao.getActivityByName(name);
        return list;
    }


}
