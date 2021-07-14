package jiangmh.demo.crm.workbench.service.impl;

import jiangmh.demo.crm.utils.DateTimeUtil;
import jiangmh.demo.crm.utils.UUIDUtil;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.CustomerDao;
import jiangmh.demo.crm.workbench.dao.TranDao;
import jiangmh.demo.crm.workbench.dao.TranHistoryDao;
import jiangmh.demo.crm.workbench.domain.Customer;
import jiangmh.demo.crm.workbench.domain.Tran;
import jiangmh.demo.crm.workbench.domain.TranHistory;
import jiangmh.demo.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class TransactionServiceImpl implements TransactionService {
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;
    @Resource
    private CustomerDao customerDao;
    @Override
    public PaginationVO<Map> pageList(Map map) {
        int total = tranDao.getTotal(map);
        List<Map> mapList = tranDao.getTranListByCondition(map);
        PaginationVO<Map> vo = new PaginationVO<Map>();
        vo.setTotal(total);
        vo.setDataList(mapList);
        return vo;
    }

    @Override
    public boolean save(Tran tran, String customerName) {
        /*
         *  1.根据客户名称在客户表进行精确查询
         *  2.将查出的客户对象的customerId进行赋值, 若没有查出无需赋值
         *  3.执行交易添加 生成交易历史
         */
        boolean f = true;
        Customer customer = customerDao.getCustomerInName(customerName);
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setName(customerName);
            customer.setOwner(tran.getOwner());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            int count = customerDao.save(customer);
            if(count!=1){
                f = false;
            }
        }
        // 赋值
        tran.setCustomerId(customer.getId());
        // 执行交易
        int count = tranDao.save(tran);
        if(count!=1){
            f = false;
        }
        // 交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(tran.getStage());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateTime(tran.getCreateTime());
        th.setCreateBy(tran.getCreateBy());
        th.setTranId(tran.getId());

        int count1 = tranHistoryDao.save(th);
        if(count1!=1){
            f = false;
        }
        return f;
    }

    @Override
    public Map detail(String id) {
        Map map = tranDao.detail(id);
        return map;
    }

    @Override
    public List<Map> getTranHistoryListByTid(String tranId) {
        List<Map> mapList = tranHistoryDao.getTranHistoryListByTid(tranId);
        return mapList;
    }

    @Override
    public boolean changeStage(Tran tran) {
        boolean f = true;
        // 根据id修改tran的stage
        int count = tranDao.updateStage(tran);
        if(count!=1){
            f = false;
        }

        // 交易历史记录
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(tran.getStage());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(tran.getEditBy());
        th.setTranId(tran.getId());
        int count2 = tranHistoryDao.save(th);
        if(count2!=1){
            f = false;
        }
        return f;
    }

    @Override
    public List<Tran> getTranListByCusId(String customerId) {
        List<Tran> tList = tranDao.getTranListByCusId(customerId);
        return tList;
    }

    @Override
    public boolean deleteTran(String id) {
        int count = tranDao.deleteTran(id);
        return count==1;
    }

    @Override
    public List<Map> getChart() {
        List<Map> m = tranDao.getChart();
        return m;
    }


}
