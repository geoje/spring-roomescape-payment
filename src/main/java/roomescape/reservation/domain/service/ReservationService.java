package roomescape.reservation.domain.service;

import org.springframework.stereotype.Service;
import roomescape.auth.dto.LoginMember;
import roomescape.exception.ResourceNotFoundException;
import roomescape.reservation.domain.dto.WaitingReservationRanking;
import roomescape.reservation.domain.entity.MemberReservation;
import roomescape.reservation.domain.entity.Reservation;
import roomescape.reservation.domain.entity.ReservationStatus;
import roomescape.reservation.dto.MemberReservationResponse;
import roomescape.reservation.dto.MyReservationResponse;
import roomescape.reservation.dto.ReservationSearchRequestParameter;
import roomescape.reservation.repository.MemberReservationRepository;
import roomescape.reservation.repository.ReservationRepository;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Stream;

@Service
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final MemberReservationRepository memberReservationRepository;

    public ReservationService(
            ReservationRepository reservationRepository,
            MemberReservationRepository memberReservationRepository
    ) {
        this.reservationRepository = reservationRepository;
        this.memberReservationRepository = memberReservationRepository;
    }

    private MemberReservation findMemberReservationById(Long id) {
        return memberReservationRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("존재하지 않는 예약입니다."));
    }

    public List<MemberReservationResponse> readReservations() {
        return memberReservationRepository.findByStatuses(
                        List.of(ReservationStatus.CONFIRMATION, ReservationStatus.PENDING)).stream()
                .map(MemberReservationResponse::from)
                .toList();
    }

    public List<MyReservationResponse> readMemberReservations(LoginMember loginMember) {
        List<MemberReservation> confirmationReservation = memberReservationRepository
                .findByMemberIdAndStatuses(loginMember.id(),
                        List.of(ReservationStatus.CONFIRMATION, ReservationStatus.PENDING));
        List<WaitingReservationRanking> waitingReservation = memberReservationRepository.
                findWaitingReservationRankingByMemberId(loginMember.id());

        return Stream.concat(
                        confirmationReservation.stream().map(MyReservationResponse::from),
                        waitingReservation.stream().map(MyReservationResponse::from))
                .sorted(Comparator.comparing(MyReservationResponse::date)
                        .thenComparing(MyReservationResponse::time))
                .toList();
    }

    public List<MemberReservationResponse> searchReservations(ReservationSearchRequestParameter searchCondition) {

        List<Reservation> reservations = reservationRepository.findByDateBetweenAndThemeId(
                searchCondition.dateFrom(),
                searchCondition.dateTo(),
                searchCondition.themeId()
        );

        return memberReservationRepository.findByMemberIdAndReservationIn(searchCondition.memberId(), reservations)
                .stream()
                .map(MemberReservationResponse::from)
                .toList();
    }

    public MemberReservation readReservation(Long id) {
        return findMemberReservationById(id);
    }

    public void deleteReservation(MemberReservation memberReservation) {
        memberReservation.validateIsBeforeNow();
        memberReservationRepository.delete(memberReservation);

        confirmFirstWaitingReservation(memberReservation.getReservation());
    }

    public void deleteReservation(MemberReservation memberReservation, LoginMember loginMember) {
        memberReservation.validateIsOwner(loginMember);
        memberReservation.validateIsBeforeNow();
        memberReservationRepository.delete(memberReservation);

        confirmFirstWaitingReservation(memberReservation.getReservation());
    }

    private void confirmFirstWaitingReservation(Reservation reservation) {
        memberReservationRepository.findFirstByReservationAndStatus(reservation, ReservationStatus.WAITING)
                .ifPresent((memberReservation) -> memberReservation.setStatus(ReservationStatus.PENDING));
    }

    public void confirmPendingReservation(Long id) {
        MemberReservation memberReservation = findMemberReservationById(id);
        memberReservation.validatePendingStatus();
        memberReservation.setStatus(ReservationStatus.CONFIRMATION);
    }
}
