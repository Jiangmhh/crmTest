package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getRemarkListByCId(String clueId);

    Integer deleteById(String id);

    Integer getCountsByCid(String s);

    Integer deleteByCid(String s);

    int updateRemark(ClueRemark clueRemark);

    int saveRemark(ClueRemark clueRemark);
}
