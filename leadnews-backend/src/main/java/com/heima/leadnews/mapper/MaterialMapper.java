package com.heima.leadnews.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heima.leadnews.entity.Material;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface MaterialMapper extends BaseMapper<Material> {

    @Update("UPDATE materials SET deleted_at = NULL WHERE id = #{id}")
    void recoverById(Long id);
}
