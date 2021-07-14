package jiangmh.demo.crm.workbench.dao;

import jiangmh.demo.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int save(Contacts cs);

    List<Contacts> getContactListById(String customerId);

    List<Contacts> getContactListByName(String name);

    int delete(String id);
}
