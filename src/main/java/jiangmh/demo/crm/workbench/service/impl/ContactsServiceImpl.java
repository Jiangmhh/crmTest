package jiangmh.demo.crm.workbench.service.impl;

import jiangmh.demo.crm.workbench.dao.ContactsDao;
import jiangmh.demo.crm.workbench.domain.Contacts;
import jiangmh.demo.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
@Service
public class ContactsServiceImpl implements ContactsService {
    @Resource
    private ContactsDao contactsDao;
    @Override
    public List<Contacts> getContactListById(String customerId) {
        List<Contacts> list = contactsDao.getContactListById(customerId);
        return list;
    }

    @Override
    public List<Contacts> getContactListByName(String name) {
        return contactsDao.getContactListByName(name);
    }

    @Override
    public boolean save(Contacts contacts) {
        int count = contactsDao.save(contacts);
        return count==1;
    }

    @Override
    public boolean deleteContact(String id) {
        int count = contactsDao.delete(id);
        return count==1;
    }


}
