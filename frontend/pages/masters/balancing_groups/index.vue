<template lang="pug">
  rest-index(
    title="バランシンググループ一覧"
    name="balancing_groups"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="名前"
            label-for="name"
            )
            b-form-input(
              id="name"
              v-model="query.name_cont"
            )
        b-col
          b-form-group(
            label="エリア"
            label-for="district_id"
            )
            b-form-select(
              id="district_id"
              v-model="query.district_id_eq"
              v-bind:options="districts"
            )
        b-col
          b-form-group(
            label="リーダーPPS"
            label-for="leader_company_id"
            )
            b-form-select(
              id="leader_company_id"
              v-model="query.leader_company_id_eq"
              v-bind:options="leader_companies"
            )
</template>

<script>
import RestIndex from '~/components/Rest/RestIndex.vue'

export default {
  components: { RestIndex },
  data() {
    return {
      fields: [
        {
          key: "id",
          label: "ID"
        },
        {
          key: "name",
          label: "名前"
        },
        {
          key: "district.name",
          label: "エリア名"
        },
        {
          key: "leader_company.name",
          label: "リーダーPPS名"
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatDatetime'
        }
      ],
      query: {
        name_cont: null,
        district_id_eq: null,
        leader_company_id_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      districts: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'}),
      leader_companies: await ctx.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>

