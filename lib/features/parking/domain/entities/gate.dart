import 'package:equatable/equatable.dart';

import 'gate_id.dart';

class Gate extends Equatable {
  const Gate({required this.id, required this.open});

  final GateId id;
  final bool open;

  Gate copyWith({bool? open}) => Gate(id: id, open: open ?? this.open);

  @override
  List<Object?> get props => [id, open];
}
