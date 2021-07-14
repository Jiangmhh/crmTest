package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    List<ActivityRemark> getActivityRemarkByAid(String id);

    int getCountByAid(String id);

    int deleteByAid(String id);

    Boolean deleteRemark(String id);

    Boolean saveRemark(ActivityRemark activityRemark);

    Boolean editRemark(ActivityRemark activityRemark);
}
