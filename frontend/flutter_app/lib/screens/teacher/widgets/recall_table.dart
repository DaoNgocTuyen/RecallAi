import 'package:flutter/material.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

class RecallTable extends StatelessWidget {
  const RecallTable({super.key, required this.headers, required this.rows});
  final List<String> headers;
  final List<List<Widget>> rows;
  @override
  Widget build(BuildContext context) => RecallCard(
    padding: 0,
    child: LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: c.maxWidth < 1000 ? 1100 : c.maxWidth,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              for (var i = 0; i < headers.length; i++)
                i: FlexColumnWidth(
                  headers[i] == 'Câu hỏi' ||
                          headers[i] == 'Lớp học' ||
                          headers[i] == 'Bài kiểm tra' ||
                          headers[i] == 'Học sinh / Sinh viên'
                      ? 2.4
                      : headers[i].isEmpty
                      ? .7
                      : 1.2,
                ),
            },
            border: const TableBorder(
              horizontalInside: BorderSide(color: RecallColors.border),
            ),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: RecallColors.background),
                children: [
                  for (final h in headers)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        h,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
              for (final row in rows)
                TableRow(
                  children: [
                    for (final cell in row)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: cell,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
