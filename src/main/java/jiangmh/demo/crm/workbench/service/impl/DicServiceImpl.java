package jiangmh.demo.crm.workbench.service.impl;

import jiangmh.demo.crm.workbench.dao.DicTypeDao;
import jiangmh.demo.crm.workbench.dao.DicValueDao;
import jiangmh.demo.crm.workbench.domain.DicType;
import jiangmh.demo.crm.workbench.domain.DicValue;
import jiangmh.demo.crm.workbench.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao;
    private DicValueDao dicValueDao;

    public void setDicTypeDao(DicTypeDao dicTypeDao) {
        this.dicTypeDao = dicTypeDao;
    }

    public void setDicValueDao(DicValueDao dicValueDao) {
        this.dicValueDao = dicValueDao;
    }
    @Override
    public Map<String, List<DicValue>> getDicList() {
        Map<String, List<DicValue>> map = new HashMap<>();
        // 获取所有字典类型
        List<DicType> typeList = dicTypeDao.getTypeList();
        // 获取每个类型对应的字典值
        for(DicType dicType : typeList){
            List<DicValue> valueList = dicValueDao.getValueList(dicType.getCode());
            map.put(dicType.getCode(), valueList);
        }
        return map;
    }
}
