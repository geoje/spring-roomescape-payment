package roomescape.payment.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import roomescape.payment.domain.Payment;
import roomescape.reservation.domain.entity.MemberReservation;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    Optional<Payment> findByMemberReservation(MemberReservation memberReservation);
}
