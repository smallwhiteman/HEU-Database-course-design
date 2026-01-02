<template>
  <div>
    <div class="header">
      已完成订单（可评价）
    </div>
    <div class="body">
      <el-table :data="tableData" style="width: 100%" class="table" border>
        <el-table-column prop="shop_name" label="店铺" width="100" align="center"></el-table-column>
        <el-table-column prop="order_money" label="订单价格" width="80" align="center"></el-table-column>
        <el-table-column prop="order_way" label="订餐方式" width="100" align="center"></el-table-column>
        <el-table-column prop="cons_name" label="订餐人姓名" width="100" align="center"></el-table-column>
        <el-table-column prop="cons_addre" label="取餐地址" width="150" align="center"></el-table-column>
        <el-table-column prop="disp_id" label="送餐员编号" width="120" align="center"></el-table-column>
        <el-table-column prop="disp_phone" label="送餐员电话" width="120" align="center"></el-table-column>
        <el-table-column prop="deliver_time" label="实际送餐时间" width="116" align="center"></el-table-column>

        <!-- 新增：评价操作列 -->
        <el-table-column label="评价" width="120" align="center">
          <template slot-scope="scope">
            <el-button
                v-if="!scope.row.has_commented"
                type="primary"
                size="mini"
                @click="openCommentDialog(scope.row)">
              去评价
            </el-button>
            <span v-else style="color: #67C23A; font-weight: bold;">已评价</span>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 评价对话框 -->
    <el-dialog title="评价店铺" :visible.sync="commentDialogVisible" width="400px" center>
      <div style="text-align: center; padding: 20px 0;">
        <div style="font-size: 18px; margin-bottom: 20px;">
          店铺： <strong>{{ currentShop }}</strong>
        </div>

        <div style="margin-bottom: 20px;">
          <span style="font-size: 16px; margin-right: 10px;">请打分：</span>
          <el-rate
              v-model="commentForm.score"
              :colors="['#99A9BF', '#F7BA2A', '#FF9900']"
              show-score
              score-template="{value} 分">
          </el-rate>
        </div>

        <el-input
            type="textarea"
            :rows="4"
            placeholder="说说你的用餐体验吧（可选）"
            v-model="commentForm.content">
        </el-input>
      </div>

      <span slot="footer" class="dialog-footer">
                <el-button @click="commentDialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="submitComment" :disabled="commentForm.score === 0">
                    提 交 评 价
                </el-button>
            </span>
    </el-dialog>
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
      commentDialogVisible: false,
      currentShop: '',
      commentForm: {
        score: 0,      // 必须从0开始，方便判断是否打分
        content: ''
      }
    }
  },
  methods: {
    async getdata() {
      try {
        const res = await this.$axios.get("/api/user/sended", {
          headers: { token: localStorage.getItem('token') }
        })
        if (res.data.status === 200) {
          this.tableData = res.data.tabledata || []

          // 遍历每个订单，检查是否已对该店铺评价过
          for (let order of this.tableData) {
            const hasRes = await this.$axios.get("/api/user/has_commented", {
              params: { shop_name: order.shop_name },
              headers: { token: localStorage.getItem('token') }
            })
            // 添加字段标记是否已评价
            this.$set(order, 'has_commented', hasRes.data.has_commented)
          }
        }
      } catch (err) {
        console.error(err)
        this.$message.error('加载订单失败')
      }
    },

    // 打开评价弹窗
    openCommentDialog(row) {
      this.currentShop = row.shop_name
      this.commentForm = {
        score: 5,   // 默认5星，体验更好
        content: ''
      }
      this.commentDialogVisible = true
    },

    // 提交评价
    submitComment() {
      if (this.commentForm.score === 0) {
        this.$message.warning('请先给店铺打个分哦~')
        return
      }

      this.$axios.post("/api/user/add_comment", {
        shop_name: this.currentShop,
        score: this.commentForm.score,
        content: this.commentForm.content
      }, {
        headers: { token: localStorage.getItem('token') }
      }).then(res => {
        if (res.data.status === 200) {
          this.$message.success('评价成功！感谢你的反馈~')
          this.commentDialogVisible = false

          // 更新当前订单的评价状态
          const order = this.tableData.find(item => item.shop_name === this.currentShop)
          if (order) {
            this.$set(order, 'has_commented', true)
          }
        } else {
          this.$message.error(res.data.msg || '评价失败')
        }
      }).catch(err => {
        console.error(err)
        this.$message.error('提交失败，请重试')
      })
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
  width: 80%;           /* 改大一点，更美观 */
  margin: auto;
  margin-top: 30px;
}

.dialog-footer {
  text-align: center;
}
</style>