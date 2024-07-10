package roomescape.member.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import roomescape.member.domain.Member;
import roomescape.member.domain.Role;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {

    Optional<Member> findByEmail(String email);

    Optional<Member> findByUsername(String username);

    Optional<Member> findByRole(Role role);
}
