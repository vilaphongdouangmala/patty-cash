import { useTranslation } from 'react-i18next'
import type { BillItem } from './bill-items-step'

interface SummaryStepProps {
  participants: string[]
  items: BillItem[]
}

export function SummaryStep({ participants, items }: SummaryStepProps) {
  const { t } = useTranslation()

  const calculateTotalPrice = () => {
    return items.reduce((sum, item) => sum + item.price, 0)
  }

  const calculatePerPersonShare = (itemIndex: number) => {
    const item = items[itemIndex]
    if (item.participants.length === 0) return 0
    return item.price / item.participants.length
  }

  const getParticipantTotal = (participant: string) => {
    return items.reduce((sum, item) => {
      if (item.participants.includes(participant)) {
        return sum + calculatePerPersonShare(items.indexOf(item))
      }
      return sum
    }, 0)
  }

  return (
    <div className="space-y-6">
      <div className="space-y-4">
        <h3 className="text-lg font-semibold text-foreground">
          {t('summary.summary')}
        </h3>

        <div className="space-y-3">
          {items.map((item, index) => (
            <div key={index} className="border rounded-lg p-4">
              <div className="flex justify-between items-center mb-2">
                <span className="font-medium text-foreground">{item.name}</span>
                <span className="text-foreground">฿{item.price.toFixed(2)}</span>
              </div>
              {item.participants.length > 0 && (
                <div className="text-sm text-muted-foreground">
                  Split among: {item.participants.join(', ')}
                </div>
              )}
            </div>
          ))}
        </div>

        <div className="border-t pt-4">
          <div className="flex justify-between items-center text-lg font-semibold">
            <span>Total</span>
            <span>฿{calculateTotalPrice().toFixed(2)}</span>
          </div>
        </div>
      </div>

      <div className="space-y-4">
        <h3 className="text-lg font-semibold text-foreground">
          Per Person Breakdown
        </h3>
        <div className="space-y-2">
          {participants.map((participant) => (
            <div
              key={participant}
              className="flex justify-between items-center p-3 bg-muted/50 rounded-lg"
            >
              <span className="font-medium text-foreground">{participant}</span>
              <span className="text-foreground">
                ฿{getParticipantTotal(participant).toFixed(2)}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
