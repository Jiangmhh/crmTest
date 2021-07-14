package jiangmh.demo.crm.workbench.service;

import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    Boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map map);

    boolean delete(String[] ids);

    Activity getActivity(String id);

    Boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getActivityRemarkByAid(String id);

    Boolean deleteRemark(String id);

    Boolean saveRemark(ActivityRemark activityRemark);

    Boolean editRemark(ActivityRemark activityRemark);

    List<Activity> getActivityByClueId(String id);

    List<Activity> getActivityListByNameAndNotCid(String name, String clueId);

    List<Activity> getActivityByName(String name);
}
