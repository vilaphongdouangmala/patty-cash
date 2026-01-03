import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { BillSplitingStep } from '@/lib/bill-spliting/enums'
import { createFileRoute } from '@tanstack/react-router'
import { Users, ReceiptText, Receipt } from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { ParticipantsStep } from '@/components/bill-spliting/participants-step'
import {
  BillItemsStep,
  type BillItem,
} from '@/components/bill-spliting/bill-items-step'
import { SummaryStep } from '@/components/bill-spliting/summary-step'

export const Route = createFileRoute('/')({
  component: App,
})

function App() {
  const { t } = useTranslation()
  const [participants, setParticipants] = useState<string[]>([])
  const [billItems, setBillItems] = useState<BillItem[]>([])

  const handleBillItemsSubmit = (items: BillItem[]) => {
    setBillItems(items)
  }

  return (
    <div className="min-h-screen bg-linear-to-br from-background to-muted/20">
      <div className="container mx-auto px-4 py-16">
        <div className="max-w-md mx-auto">
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-4 text-2xl font-bold">
              1
            </div>
            <div className="flex items-center justify-center gap-4 mb-4">
              <h1 className="text-2xl font-bold text-foreground">
                {t('participants.title')}
              </h1>
            </div>
          </div>
          <div className="bg-card border rounded-xl shadow-sm p-4">
            <Tabs defaultValue={BillSplitingStep.Participants}>
              <TabsList className="mb-4 w-full">
                <TabsTrigger
                  className="w-full py-4"
                  value={BillSplitingStep.Participants}
                >
                  <Users />
                </TabsTrigger>
                <TabsTrigger
                  className="w-full py-4"
                  value={BillSplitingStep.BillItems}
                >
                  <ReceiptText />
                </TabsTrigger>
                <TabsTrigger
                  className="w-full py-4"
                  value={BillSplitingStep.Summary}
                >
                  <Receipt />
                </TabsTrigger>
              </TabsList>
              <TabsContent value={BillSplitingStep.Participants}>
                <ParticipantsStep
                  participants={participants}
                  onParticipantsChange={setParticipants}
                />
              </TabsContent>
              <TabsContent value={BillSplitingStep.BillItems}>
                <BillItemsStep onSubmit={handleBillItemsSubmit} />
              </TabsContent>
              <TabsContent value={BillSplitingStep.Summary}>
                <SummaryStep participants={participants} items={billItems} />
              </TabsContent>
            </Tabs>
          </div>
        </div>
      </div>
    </div>
  )
}
