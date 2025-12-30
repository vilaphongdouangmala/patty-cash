import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

const resources = {
  en: {
    translation: {
      participants: {
        title: 'Add Your Companions',
        participant: 'Participant',
        namePlaceholder: 'Enter a name',
        addedNames: 'Added names',
        clearAll: 'Clear all',
        emptyState: 'Start by adding the first participant',
        duplicateError: 'This participant is already added',
      },
      billItems: {
        title: 'Add Your Items',
        items: 'Items',
        nameRequired: 'Name is required',
        priceRequired: 'Price is required',
      },
      summary: {
        summary: 'Summary',
      },
    },
  },
  th: {
    translation: {
      participants: {
        title: 'เพิ่มผู้ร่วมรับประทาน',
        participant: 'ผู้ร่วมรับประทาน',
        namePlaceholder: 'กรอกชื่อ',
        addedNames: 'รายชื่อที่เพิ่ม',
        clearAll: 'ลบทั้งหมด',
        emptyState: 'เริ่มต้นโดยการเพิ่มผู้ร่วมรับประทานคนแรก',
        duplicateError: 'มีผู้ร่วมรับประทานนี้อยู่แล้ว',
      },
      billItems: {
        title: 'เพิ่มรายการ',
        items: 'รายการ',
        nameRequired: 'ชื่อสินค้า/บริการ',
        priceRequired: 'ราคา',
      },
      summary: {
        summary: 'สรุป',
      },
    },
  },
}

i18n.use(initReactI18next).init({
  resources,
  lng: 'en',
  fallbackLng: 'en',
  interpolation: {
    escapeValue: false,
  },
})

export default i18n
