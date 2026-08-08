package com.heima.leadnews.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_agreement_logs")
public class UserAgreementLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Integer agreementType;

    private LocalDateTime agreedAt;

    private String ipAddress;
}
