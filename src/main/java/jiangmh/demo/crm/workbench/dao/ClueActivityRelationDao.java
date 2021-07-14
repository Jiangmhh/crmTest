package jiangmh.demo.crm.workbench.dao;


import jiangmh.demo.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    int bundActivity(List<ClueActivityRelation> list);

    Integer deleteRelationById(String id);

    List<ClueActivityRelation> getListByCId(String clueId);
}
