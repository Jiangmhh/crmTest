package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranHistoryDao {

    int save(TranHistory th);

    List<Map> getTranHistoryListByTid(String tranId);
}
