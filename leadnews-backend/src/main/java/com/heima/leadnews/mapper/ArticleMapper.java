package com.heima.leadnews.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.heima.leadnews.entity.Article;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ArticleMapper extends BaseMapper<Article> {

    @Update("UPDATE articles SET deleted_at = NULL WHERE id = #{id}")
    void recoverById(Long id);
}
