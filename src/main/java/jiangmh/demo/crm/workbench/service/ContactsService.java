package jiangmh.demo.crm.workbench.service;

import jiangmh.demo.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactListById(String customerId);

    List<Contacts> getContactListByName(String name);

    boolean save(Contacts contacts);

    boolean deleteContact(String id);
}
