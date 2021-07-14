package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    int getTotal(Map map);

    List<Map> getTranListByCondition(Map map);

    Map detail(String id);

    int updateStage(Tran tran);

    List<Tran> getTranListByCusId(String customerId);

    int deleteTran(String id);

    List<Map> getChart();
}
