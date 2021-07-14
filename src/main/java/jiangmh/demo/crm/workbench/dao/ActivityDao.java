package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);

    int getTotalByCondition(Map map);

    List<Activity> getActivityListByCondition(Map map);

    int delete(String[] ids);

    Activity getActivity(String id);

    Boolean update(Activity activity);

    Activity getDetailById(String id);

    List<Activity> getActivityByClueId(String id);

    List<Activity> getActivityListByNameAndNotCid(@Param("name")String name, @Param("clueId")String clueId);

    List<Activity> getActivityByName(String name);
}
