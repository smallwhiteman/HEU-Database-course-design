<template>
  <div>
    <div class="header">
      评论管理
    </div>
    <div class="body">
      <!-- 搜索框 -->
      <div style="margin-bottom: 20px;">
        <el-input
            v-model="searchForm.shop_name"
            placeholder="输入店铺名称搜索"
            style="width: 300px; margin-right: 10px;"
            clearable
            @keyup.enter.native="fetchComments"
        ></el-input>
        <el-button type="primary" @click="fetchComments" icon="el-icon-search">搜索</el-button>
        <el-button @click="resetSearch" style="margin-left: 10px;">重置</el-button>
      </div>

      <el-table :data="tableData" style="width: 89%" class="table">
        <el-table-column prop="comment_id" label="评论ID" width="100" align="center"></el-table-column>
        <el-table-column prop="shop_name" label="店铺名称" width="150" align="center"></el-table-column>
        <el-table-column prop="username" label="用户名" width="120" align="center"></el-table-column>
        <el-table-column prop="telephone" label="电话" width="140" align="center"></el-table-column>
        <el-table-column prop="score" label="评分" width="100" align="center">
          <template slot-scope="scope">
            <el-rate v-model="scope.row.score" disabled show-score></el-rate>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="评论内容" min-width="300">
          <template slot-scope="scope">
            <div style="max-height: 60px; overflow: hidden;" :title="scope.row.content">
              {{ scope.row.content }}
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="create_time" label="评论时间" width="180" align="center"></el-table-column>
        <el-table-column prop="operate" label="操作" width="120" align="center">
          <template slot-scope="scope">
            <el-button size="small" type="danger" @click="showdia_dlt(scope.row)">删除</el-button>
          </template>
        </el-table-column>
        <el-table-column width="120" align="center">
          <template slot="header">
            <!-- 分页控制 -->
            <el-pagination
                v-model="currentPage"
                :page-size="pageSize"
                :page-sizes="[10, 20, 50]"
                layout="sizes, prev, pager, next"
                :total="total"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                style="float: left;"
            ></el-pagination>
          </template>
        </el-table-column>
      </el-table>

      <!-- 删除确认对话框 -->
      <el-dialog title="删除评论" :visible.sync="dia_dlt" width="30%">
        <div>
          确定删除此评论吗？<br>
          <span style="color: #f56c6c;">店铺：{{ deleteComment.shop_name }}</span><br>
          <span style="color: #f56c6c;">用户：{{ deleteComment.username }}</span>
        </div>
        <div style="text-align: center;">
          <el-button @click="dia_dlt = false">取消</el-button>
          <el-button type="primary" @click="deletedispatcher()">确定删除</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
export default {
  created() {
    this.getdata()
  },
  data() {
    return {
      tableData: [],
      // 分页
      currentPage: 1,
      pageSize: 10,
      total: 0,
      // 搜索
      searchForm: {
        shop_name: ''
      },
      // 删除
      dia_dlt: false,
      deleteComment: {},
    }
  },
  methods: {
    getdata(page = 1, pageSize = 10) {
      const params = {
        page: page,
        per_page: pageSize
      }
      if (this.searchForm.shop_name) {
        params.shop_name = this.searchForm.shop_name
      }

      this.$axios.get("/api/manager/comments", {
        params: params,
        headers: {
          token: localStorage.getItem('token')
        }
      }).then((res) => {
        console.log(res.data);
        if (res.data.status == 200) {
          this.tableData = res.data.data || [];
          this.total = res.data.total || 0;
          this.currentPage = res.data.page || 1;
          this.pageSize = res.data.per_page || 10;
        }
      }).catch(err => {
        console.error('获取评论失败:', err);
        this.$message.error('获取评论列表失败');
      })
    },

    // 搜索评论
    fetchComments() {
      this.currentPage = 1;
      this.getdata();
    },

    // 重置搜索
    resetSearch() {
      this.searchForm.shop_name = '';
      this.fetchComments();
    },

    // 分页改变
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
      this.getdata();
    },
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getdata();
    },

    // 显示删除对话框
    showdia_dlt(row) {
      this.deleteComment = row;
      this.dia_dlt = true;
    },

    // 删除评论
    deletedispatcher() {
      this.$axios.delete("/api/manager/comments/" + this.deleteComment.comment_id, {
        headers: {
          token: localStorage.getItem('token')
        }
      }).then((res) => {
        console.log(res.data);
        if (res.data.status == 200) {
          this.$message({
            message: res.data.msg || "删除成功",
            type: "success"
          });
          this.dia_dlt = false;
          this.getdata(); // 重新加载数据
        } else {
          this.$message({
            message: res.data.msg || "删除失败",
            type: "error"
          });
        }
      }).catch(err => {
        console.error('删除评论失败:', err);
        this.$message.error('删除失败');
      });
    }
  }
}
</script>

<style scoped>
.header {
  width: 100%;
  height: 10%;
  text-align: center;
  line-height: 64px;
  font-size: 20px;
  font-weight: 800;
  border-bottom: 1px solid #e3e3e3;
}

.body {
  width: 80%;
  margin: auto;
  margin-top: 30px;
}

.table {
  margin-top: 20px;
}

/* 评分星星样式优化 */
::v-deep .el-rate {
  display: inline-block;
  width: 120px;
  padding-right: 50px;
}
</style>