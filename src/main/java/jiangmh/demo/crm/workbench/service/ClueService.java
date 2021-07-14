package jiangmh.demo.crm.workbench.service;

import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.domain.Activity;
import jiangmh.demo.crm.workbench.domain.Clue;
import jiangmh.demo.crm.workbench.domain.ClueRemark;
import jiangmh.demo.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {

    Boolean saveClue(Clue clue);

    PaginationVO<Clue> pageList(Map map);

    Clue getClueById(String id);

    Clue getDetail(String id);

    Boolean deleteRelationById(String id);

    Boolean bundActivity(String[] ids, String clueId);

    Boolean convert(String clueId, Tran t, String createBy);

    Boolean update(Clue clue);

    Boolean delete(String[] id);

    List<ClueRemark> getRemarkListByCid(String clueId);

    boolean updateRemark(ClueRemark clueRemark);

    boolean deleteById(String id);

    boolean saveRemark(ClueRemark clueRemark);
}
