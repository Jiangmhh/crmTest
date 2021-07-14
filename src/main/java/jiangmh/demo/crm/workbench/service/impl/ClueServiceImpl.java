package jiangmh.demo.crm.workbench.service.impl;

import jiangmh.demo.crm.exception.ConvertDefaultException;
import jiangmh.demo.crm.utils.DateTimeUtil;
import jiangmh.demo.crm.utils.UUIDUtil;
import jiangmh.demo.crm.vo.PaginationVO;
import jiangmh.demo.crm.workbench.dao.*;
import jiangmh.demo.crm.workbench.domain.*;
import jiangmh.demo.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;
    @Resource
    private ActivityDao activityDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    @Override
    public Boolean saveClue(Clue clue) {
        Boolean flag = false;
        int result = clueDao.saveClue(clue);
        if(result == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    public PaginationVO<Clue> pageList(Map map) {
        PaginationVO<Clue> vo = new PaginationVO<>();
        // 根据情况查询所有记录
        int count = clueDao.getClueTotalByCondition(map);
        // 分页查询所有clue
        List<Clue> clueList = clueDao.getClueListByCondition(map);
        vo.setDataList(clueList);
        vo.setTotal(count);
        return vo;
    }

    @Override
    public Clue getClueById(String id) {
        Clue clue = clueDao.getClueById(id);
        return clue;
    }

    @Override
    public Clue getDetail(String id) {
        Clue clue = clueDao.getDetail(id);
        return clue;
    }

    @Override
    public Boolean deleteRelationById(String id) {
        Boolean flag = false;
        int count = clueActivityRelationDao.deleteRelationById(id);
        if(count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    public Boolean bundActivity(String[] ids, String clueId) {
        Boolean f = false;
        List<ClueActivityRelation> list = new ArrayList<>();
        for(String str : ids){
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(str);
            car.setClueId(clueId);
            list.add(car);
        }
        int count = clueActivityRelationDao.bundActivity(list);
        if(count == ids.length){
            f = true;
        }
        return f;
    }

    @Transactional
    @Override
    public Boolean convert(String clueId, Tran t, String createBy) {
        Boolean flag = true;
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueDao.getClueById(clueId);
        // (2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        String company = clue.getCompany();
        Customer c = customerDao.getCustomerByName(company);
        if(c == null){
            // 创建新客户
            c = new Customer();
            c.setId(UUIDUtil.getUUID());
            c.setOwner(clue.getOwner());
            c.setName(company);
            c.setWebsite(clue.getWebsite());
            c.setPhone(clue.getPhone());
            c.setCreateBy(createBy);
            c.setCreateTime(DateTimeUtil.getSysTime());
            c.setDescription(clue.getDescription());
            c.setContactSummary(clue.getContactSummary());
            c.setNextContactTime(clue.getNextContactTime());
            c.setAddress(clue.getAddress());
            int count = customerDao.save(c);
            if(count!=1){
                flag = false;
            }
        }
        // (3) 通过线索对象提取联系人信息，保存联系人
        Contacts cs = new Contacts();
        cs.setId(UUIDUtil.getUUID());
        cs.setOwner(clue.getOwner());
        cs.setSource(clue.getSource());
        cs.setCustomerId(c.getId());
        cs.setFullname(clue.getFullname());
        cs.setAppellation(clue.getAppellation());
        cs.setEmail(clue.getEmail());
        cs.setMphone(clue.getMphone());
        cs.setJob(clue.getJob());
        cs.setCreateBy(clue.getCreateBy());
        cs.setCreateTime(clue.getCreateTime());
        cs.setDescription(clue.getDescription());
        cs.setContactSummary(clue.getContactSummary());
        cs.setNextContactTime(clue.getNextContactTime());
        cs.setAddress(clue.getAddress());
        int count = contactsDao.save(cs);
        if(count!=1){
            flag = false;
        }

        // (4) 线索备注转换到客户备注以及联系人备注
        // 查询所有线索的备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkListByCId(clueId);
        List<CustomerRemark> customerRemarkList = new ArrayList<>();
        List<ContactsRemark> contactsRemarksList = new ArrayList<>();

        for(ClueRemark cr : clueRemarkList){
            CustomerRemark csr = new CustomerRemark();
            ContactsRemark csr2 = new ContactsRemark();
            csr.setId(UUIDUtil.getUUID());
            csr.setCreateBy(createBy);
            csr.setCreateTime(DateTimeUtil.getSysTime());
            csr.setCustomerId(c.getId());
            csr.setNoteContent(cr.getNoteContent());
            csr.setEditFlag("0");

            csr2.setId(UUIDUtil.getUUID());
            csr2.setCreateBy(createBy);
            csr2.setCreateTime(DateTimeUtil.getSysTime());
            csr2.setContactsId(cs.getId());
            csr2.setNoteContent(cr.getNoteContent());
            csr2.setEditFlag("0");

            customerRemarkList.add(csr);
            contactsRemarksList.add(csr2);

        }
        // 添加至客户的备注
        int count2 = customerRemarkDao.save(customerRemarkList);
        if(count2 != customerRemarkList.size()){
            flag = false;
        }
        // 添加至联系人的备注
        int count3 = contactsRemarkDao.save(contactsRemarksList);
        if(count3 != contactsRemarksList.size()){
            flag = false;
        }

        // (5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByCId(clueId);
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
        for(ClueActivityRelation car : clueActivityRelationList){
            String activityId = car.getActivityId();
            ContactsActivityRelation csar = new ContactsActivityRelation();
            csar.setId(UUIDUtil.getUUID());
            csar.setActivityId(activityId);
            csar.setContactsId(cs.getId());
            contactsActivityRelationList.add(csar);
        }
        int count4 = contactsActivityRelationDao.save(contactsActivityRelationList);
        if(count4 != contactsActivityRelationList.size()){
            flag = false;
        }

        // (6) 如果有创建交易需求，创建一条交易
        if(t!=null){
            t.setId(UUIDUtil.getUUID());
            t.setOwner(c.getOwner());
            t.setCreateBy(createBy);
            t.setCreateTime(DateTimeUtil.getSysTime());
            t.setCustomerId(c.getId());
            t.setContactsId(cs.getId());
            t.setSource(cs.getSource());
            t.setDescription(cs.getDescription());
            t.setContactSummary(c.getContactSummary());
            t.setNextContactTime(c.getNextContactTime());

            int count5 = tranDao.save(t);
            if(count5!=1){
                flag = false;
            }
            // (7) 如果创建了交易，则创建一条该交易下的交易历史
            String tranId = t.getId();
            TranHistory th = new TranHistory();
            th.setId(UUIDUtil.getUUID());
            th.setCreateBy(createBy);
            th.setCreateTime(DateTimeUtil.getSysTime());
            th.setExpectedDate(t.getExpectedDate());
            th.setMoney(t.getMoney());
            th.setStage(t.getStage());
            th.setTranId(t.getId());
            int count6 = tranHistoryDao.save(th);
            if(count6!=1){
                flag = false;
            }
        }

        // (8) 删除线索备注
        for(ClueRemark cr : clueRemarkList){
            String id = cr.getId();
            Integer count7 = clueRemarkDao.deleteById(id);
            if(count7!=1){
//            flag = false;
                throw new ConvertDefaultException("转换-删除线索备注失败");
            }
        }

        // (9) 删除线索和市场活动的关系
        for(ClueActivityRelation car : clueActivityRelationList){
            Integer count8 = clueActivityRelationDao.deleteRelationById(car.getId());
            if(count8!=1){
                //flag = false;
                throw new ConvertDefaultException("转换-删除线索与市场活动备注失败");
            }
        }
        // (10) 删除线索
        int count9 = clueDao.delete(clueId);
        if(count9!=1){
//            flag = false;
            throw new ConvertDefaultException("转换-删除线索失败");
        }
        return flag;

    }

    @Override
    public Boolean update(Clue clue) {
        Boolean f = false;
        int count = clueDao.update(clue);
        if(count==1){
            f = true;
        }
        return f;
    }

    @Override
    public Boolean delete(String[] id) {
        boolean f = true;
        // 删除线索备注
        for(String s : id){
            Integer count = clueRemarkDao.getCountsByCid(s);
            Integer count2 = clueRemarkDao.deleteByCid(s);
            if(count!=count2){
                f = false;
            }
        }
        // 删除线索
        int counts = clueDao.deleteByIds(id);
        if(counts!=id.length){
            f = false;
        }
        return f;
    }

    @Override
    public List<ClueRemark> getRemarkListByCid(String clueId) {
        List<ClueRemark> list = clueRemarkDao.getRemarkListByCId(clueId);
        return list;
    }

    @Override
    public boolean updateRemark(ClueRemark clueRemark) {
        boolean f = true;
        int count = clueRemarkDao.updateRemark(clueRemark);
        if(count !=1){
            f = false;
        }
        return f;
    }

    @Override
    public boolean deleteById(String id) {
        boolean f = true;
        int count = clueRemarkDao.deleteById(id);
        if(count !=1){
            f = false;
        }
        return f;
    }

    @Override
    public boolean saveRemark(ClueRemark clueRemark) {
        boolean f = true;
        int count = clueRemarkDao.saveRemark(clueRemark);
        if(count !=1){
            f = false;
        }
        return f;
    }

}
