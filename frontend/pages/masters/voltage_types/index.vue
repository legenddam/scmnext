<template lang="pug">
  rest-index(
    title="電圧種別一覧"
    name="voltage_types"
    v-bind:fields="fields"
    v-bind:list-only="true"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="名前"
            label-for="name_cont"
            )
            b-form-input(
              id="name_cont"
              v-model="query.name_cont"
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
          key: "created_at",
          label: "作成日時",
          formatter: 'formatTime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatTime'
        }
      ],
      query: {
        name_cont: null
      }
    }
  }
}
</script>

