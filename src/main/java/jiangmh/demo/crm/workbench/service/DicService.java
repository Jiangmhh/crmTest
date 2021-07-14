package jiangmh.demo.crm.workbench.service;

import jiangmh.demo.crm.workbench.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getDicList();
}
