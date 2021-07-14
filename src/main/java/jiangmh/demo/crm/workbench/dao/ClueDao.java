package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int saveClue(Clue clue);

    int getClueTotalByCondition(Map map);

    List<Clue> getClueListByCondition(Map map);

    Clue getClueById(String id);

    Clue getDetail(String id);

    Integer delete(String clueId);

    int update(Clue clue);

    int deleteByIds(String[] id);
}
