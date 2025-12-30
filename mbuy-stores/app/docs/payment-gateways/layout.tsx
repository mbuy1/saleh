import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'دليل بوابات الدفع | MBUY',
  description: 'دليل شامل لإعداد بوابات الدفع - مُيسر، تاب، باي تابز، هايبر باي',
};

export default function PaymentGatewaysDocsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return children;
}
