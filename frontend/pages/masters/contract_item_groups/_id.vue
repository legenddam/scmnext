<template lang="pug">
  rest-form(
    title="契約アイテムグループ詳細"
    name="contract_item_group"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
    v-bind:can-edit="false"
  )
</template>

<script>
import RestForm from '~/components/Rest/RestForm.vue'

export default {
  components: {RestForm},
  data() {
    return {
      id: null,
      fields: [
        {
          key: "id",
          type: "hidden"
        },
        {
          key: "name",
          type: "text",
          label: "名前"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        voltage_type_id: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>

