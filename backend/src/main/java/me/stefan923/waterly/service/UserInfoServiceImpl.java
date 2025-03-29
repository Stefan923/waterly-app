package me.stefan923.waterly.service;

import me.stefan923.waterly.dto.UserInfoRequest;
import me.stefan923.waterly.dto.UserInfoResponse;
import me.stefan923.waterly.entity.UserAccount;
import me.stefan923.waterly.entity.UserInfo;
import me.stefan923.waterly.repository.UserInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class UserInfoServiceImpl implements UserInfoService {

    private final MongoTemplate mongoTemplate;
    private final UserInfoRepository userInfoRepository;

    @Autowired
    public UserInfoServiceImpl(MongoTemplate mongoTemplate, UserInfoRepository userInfoRepository) {
        this.mongoTemplate = mongoTemplate;
        this.userInfoRepository = userInfoRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<UserInfoResponse> getByUserAccountId(String id) {
        return userInfoRepository.findByUserId(id).map(UserInfoResponse::new);
    }

    @Override
    @Transactional
    public Optional<UserInfoResponse> save(UserInfoRequest userInfoRequest) throws Exception {
        if (!isUserIdUnique(userInfoRequest.getUserId())) {
            throw new Exception("This user id has already been used.");
        }

        if (!doesUserIdExist(userInfoRequest.getUserId())) {
            throw new Exception("This user id is not associated to an account.");
        }

        try {
            return Optional.of(userInfoRepository.save(UserInfo.builder()
                    .userId(userInfoRequest.getUserId())
                    .firstName(userInfoRequest.getFirstName())
                    .lastName(userInfoRequest.getLastName())
                    .dateOfBirth(userInfoRequest.getDateOfBirth())
                    .gender(userInfoRequest.getGender())
                    .weight(userInfoRequest.getWeight())
                    .height(userInfoRequest.getHeight())
                    .build()
            )).map(UserInfoResponse::new);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    @Override
    @Transactional
    public Optional<UserInfoResponse> update(UserInfoRequest userInfoRequest) throws Exception {
        String userId = userInfoRequest.getUserId();

        UserInfo userInfo = userInfoRepository.findByUserId(userId)
                .orElseThrow(() -> new Exception("This user id is not associated to an account."));

        return Optional.of(userInfoRepository.save(UserInfo.builder()
                .id(userInfo.getId())
                .userId(userId)
                .firstName(userInfoRequest.getFirstName())
                .lastName(userInfoRequest.getLastName())
                .dateOfBirth(userInfoRequest.getDateOfBirth())
                .gender(userInfoRequest.getGender())
                .weight(userInfoRequest.getWeight())
                .height(userInfoRequest.getHeight())
                .build()
        )).map(UserInfoResponse::new);
    }

    @Override
    @Transactional
    public void delete(String userId) throws Exception {
        UserInfo userInfo = userInfoRepository.findByUserId(userId)
                .orElseThrow(() -> new Exception("This user id is not associated to an account."));

        userInfoRepository.delete(userInfo);
    }

    @Transactional(readOnly = true)
    public boolean isUserIdUnique(String userId) {
        if (userId == null) {
            return false;
        }

        Query query = new Query();
        query.addCriteria(Criteria.where("userId").is(userId));
        UserInfo userInfo = mongoTemplate.findOne(query, UserInfo.class);

        return userInfo == null;
    }

    @Transactional(readOnly = true)
    public boolean doesUserIdExist(String userId) {
        return mongoTemplate.exists(Query.query(Criteria.where("id").is(userId)), UserAccount.class);
    }

}
