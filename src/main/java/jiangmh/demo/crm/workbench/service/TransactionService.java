package jiangmh.demo.crm.workbench.service;

import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    PaginationVO<Map> pageList(Map map);

    boolean save(Tran tran, String customerName);

    Map detail(String id);

    List<Map> getTranHistoryListByTid(String tranId);

    boolean changeStage(Tran tran);

    List<Tran> getTranListByCusId(String customerId);

    boolean deleteTran(String id);

    List<Map> getChart();
}
